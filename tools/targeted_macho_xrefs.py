#!/usr/bin/env python3
"""Fast, bounded ARM64 Mach-O string-reference scan; no whole-image disassembler."""
import pathlib
import re
import struct
import sys

ROOT = pathlib.Path.cwd()
OUT = ROOT / "analysis-output"
OUT.mkdir(exist_ok=True)
apps = list((ROOT / "ipa-work" / "extracted").rglob("Spotify.app"))
if not apps:
    raise SystemExit("Spotify.app not found after IPA extraction")
binary = apps[0] / "Spotify"
blob = binary.read_bytes()

TERMS = re.compile(
    rb"playerPool|internalPlayerFactory|playbackRequestFactory|audioCoordinator|"
    rb"hasStartedPlayback|unmutedHandleProvider|playingTransitionContext|"
    rb"MixingTransitionPlayer|MixingCoreAutomix|playerLimit|MultiPlayer_PlayerImpl|"
    rb"InternalPlayerImpl|InternalAudioCoordinator",
    re.I,
)

def choose_slice(data):
    magic = data[:4]
    if magic in (b"\xcf\xfa\xed\xfe", b"\xfe\xed\xfa\xcf"):
        return data, 0
    # FAT_MAGIC/FAT_MAGIC_64, big-endian universal header.
    if magic not in (b"\xca\xfe\xba\xbe", b"\xca\xfe\xba\xbf"):
        raise ValueError("Unsupported Mach-O magic: " + magic.hex())
    is64 = magic == b"\xca\xfe\xba\xbf"
    nfat = struct.unpack_from(">I", data, 4)[0]
    entfmt = ">IIQQII" if is64 else ">IIIII"
    entsize = struct.calcsize(entfmt)
    arm = 0x0100000C
    for i in range(nfat):
        ent = struct.unpack_from(entfmt, data, 8 + i * entsize)
        if ent[0] == arm:
            off, size = ent[2], ent[3]
            return data[off:off + size], off
    raise ValueError("No arm64 slice in universal executable")

image, slice_file_base = choose_slice(blob)
if image[:4] != b"\xcf\xfa\xed\xfe":
    raise ValueError("Selected arm64 slice is not little-endian 64-bit Mach-O")
_, _, _, _, ncmds, sizeofcmds, _, _ = struct.unpack_from("<IiiIIIII", image, 0)
commands = []
sections = []
symtab = None
pos = 32
for _ in range(ncmds):
    cmd, cmdsize = struct.unpack_from("<II", image, pos)
    if cmd == 0x19:  # LC_SEGMENT_64
        seg = struct.unpack_from("<II16sQQQQiiII", image, pos)
        segname = seg[2].split(b"\0", 1)[0].decode("ascii", "replace")
        vmaddr, vmsize, fileoff, filesize, initprot, nsects = seg[3], seg[4], seg[5], seg[6], seg[8], seg[9]
        commands.append((segname, vmaddr, vmsize, fileoff, filesize, initprot))
        sp = pos + 72
        for _j in range(nsects):
            sec = struct.unpack_from("<16s16sQQIIIIIIII", image, sp)
            sect = sec[0].split(b"\0", 1)[0].decode("ascii", "replace")
            sseg = sec[1].split(b"\0", 1)[0].decode("ascii", "replace")
            sections.append((sseg, sect, sec[2], sec[3], sec[4], sec[5]))
            sp += 80
    elif cmd == 0x2:  # LC_SYMTAB
        symtab = struct.unpack_from("<IIIIII", image, pos)
    pos += cmdsize

if not commands:
    raise ValueError("No 64-bit Mach-O segments found")

def fileoff_for_vmaddr(addr):
    for _name, vm, _vmsz, off, fsz, _prot in commands:
        if vm <= addr < vm + fsz:
            return off + (addr - vm)
    return None

def signed(value, bits):
    return value - (1 << bits) if value & (1 << (bits - 1)) else value

targets = {}
for seg, sect, addr, size, off, _flags in sections:
    if sect not in ("__cstring", "__objc_methname", "__objc_classname", "__swift5_reflstr", "__const"):
        continue
    if off + size > len(image):
        continue
    raw = image[off:off + size]
    for match in TERMS.finditer(raw):
        # Include a short string fragment, not an unbounded binary run.
        start = match.start()
        end = raw.find(b"\0", start, min(len(raw), start + 256))
        if end < 0:
            end = min(len(raw), match.end() + 96)
        label = raw[start:end].decode("utf-8", "replace")
        targets[addr + start] = label

text_sections = [(addr, size, off) for _sg, sect, addr, size, off, _fl in sections if sect == "__text" and off + size <= len(image)]
if not text_sections:
    raise ValueError("No __text section found")

hits = []
for base, size, off in text_sections:
    end = off + size - 4
    pc = base
    while off <= end:
        insn = struct.unpack_from("<I", image, off)[0]
        # ADR (PC-relative) literal address.
        if insn & 0x9F000000 == 0x10000000:
            imm = ((insn >> 5) & 0x7FFFF) | (((insn >> 29) & 3) << 19)
            dest = pc + signed(imm, 21)
            if dest in targets:
                hits.append((pc, dest, "ADR", insn))
        # ADRP followed by ADD-immediate to form an exact string address.
        if insn & 0x9F000000 == 0x90000000:
            imm = ((insn >> 5) & 0x7FFFF) | (((insn >> 29) & 3) << 19)
            page = (pc & ~0xFFF) + (signed(imm, 21) << 12)
            rd = insn & 31
            for delta in (4, 8, 12, 16):
                if off + delta > end:
                    break
                nxt = struct.unpack_from("<I", image, off + delta)[0]
                if nxt & 0x7F000000 != 0x11000000 or ((nxt >> 5) & 31) != rd:
                    continue
                imm12 = (nxt >> 10) & 0xFFF
                if (nxt >> 22) & 1:
                    imm12 <<= 12
                dest = page + imm12
                if dest in targets:
                    hits.append((pc, dest, "ADRP+ADD", insn))
                break
        pc += 4
        off += 4

# Report FairPlay status and segment layout so encrypted/mapped code is explicit.
cryptid = "not found"
cmdpos = 32
for _ in range(ncmds):
    cmd, cmdsize = struct.unpack_from("<II", image, cmdpos)
    if cmd == 0x2C:  # LC_ENCRYPTION_INFO_64
        _c, _sz, _cryptoff, _cryptsize, cryptid, _pad = struct.unpack_from("<IIIIII", image, cmdpos)
        cryptid = str(cryptid)
    cmdpos += cmdsize

out = OUT / "targeted-player-xrefs.txt"
with out.open("w", encoding="utf-8") as f:
    f.write("Targeted Spotify ARM64 Mach-O reference scan (static only)\n")
    f.write(f"Binary: {binary.relative_to(ROOT)}\nSlice file offset: {slice_file_base}\n")
    f.write(f"FairPlay cryptid: {cryptid}\nTarget metadata strings: {len(targets)}\n")
    f.write("Reference forms scanned: ADR and ADRP+ADD in __text\n\n")
    for addr, text in sorted(targets.items()):
        f.write(f"STRING 0x{addr:x} {text}\n")
    f.write(f"\nDirect code references found: {len(hits)}\n")
    for code, dest, form, raw in hits:
        f.write(f"{form} code=0x{code:x} fileoff=0x{fileoff_for_vmaddr(code):x} target=0x{dest:x} {targets[dest]} insn=0x{raw:08x}\n")
    if not hits:
        f.write("No exact ADR/ADRP+ADD references were found. This is inconclusive: Swift may use relative metadata tables, indirect references, or encrypted code.\n")
print(f"Wrote {out}; strings={len(targets)}, code references={len(hits)}, cryptid={cryptid}", flush=True)
print("----- bounded scan report -----", flush=True)
print(out.read_text(encoding="utf-8")[-16000:], flush=True)

