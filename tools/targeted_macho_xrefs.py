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

def cstring_at_vmaddr(addr):
    off = fileoff_for_vmaddr(addr)
    if off is None:
        return ""
    end = image.find(b"\0", off, min(len(image), off + 512))
    if end < 0:
        end = min(len(image), off + 160)
    return image[off:end].decode("utf-8", "replace")

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
data_refs = {}
data_sections = [(seg, sect, addr, size, off) for seg, sect, addr, size, off, _fl in sections
                 if sect != "__text" and off + size <= len(image)
                 and (sect.startswith("__swift5_") or sect.startswith("__objc_")
                      or sect in ("__const", "__data_const", "__got", "__la_symbol_ptr"))]
for _seg, _sect, base, size, off in data_sections:
    # Swift and Objective-C metadata commonly holds relative pointers. Also
    # check pointer slots, because code may load an indirect selector/name.
    for rel in range(0, max(0, size - 7), 4):
        place = base + rel
        value64 = struct.unpack_from("<Q", image, off + rel)[0]
        if value64 in targets:
            data_refs[place] = value64
        value32 = struct.unpack_from("<i", image, off + rel)[0]
        for candidate in (place + value32, place + 4 + value32):
            if candidate in targets:
                data_refs[place] = candidate
                break

# Decode the published Swift reflection field-descriptor layout only far
# enough to associate matching property names with their owning type strings.
field_descriptors = {}
for _seg, sect, base, size, off, _fl in sections:
    if sect != "__swift5_fieldmd" or off + size > len(image):
        continue
    p = 0
    while p + 16 <= size:
        type_rel, super_rel, kind, record_size, count = struct.unpack_from("<iiHHI", image, off + p)
        if kind > 6 or record_size < 12 or record_size > 128 or count > 256 or p + 16 + record_size * count > size:
            p += 4
            continue
        desc_addr = base + p
        owner = cstring_at_vmaddr(desc_addr + type_rel) if type_rel else ""
        found = []
        for idx in range(count):
            rec_off = p + 16 + idx * record_size
            rec_addr = base + rec_off
            _flags, field_type_rel, field_name_rel = struct.unpack_from("<Iii", image, off + rec_off)
            field_name = cstring_at_vmaddr(rec_addr + 8 + field_name_rel) if field_name_rel else ""
            if field_name and TERMS.search(field_name.encode("utf-8", "replace")):
                found.append((field_name, cstring_at_vmaddr(rec_addr + 4 + field_type_rel) if field_type_rel else ""))
        if found:
            field_descriptors[desc_addr] = (owner, kind, found)
        p += 16 + record_size * count

type_associations = []
type_descriptors = []
for _seg, sect, base, size, off, _fl in sections:
    if sect != "__swift5_types" or off + size > len(image):
        continue
    for p in range(0, size - 3, 4):
        desc_addr = base + p + struct.unpack_from("<i", image, off + p)[0]
        desc_off = fileoff_for_vmaddr(desc_addr)
        if desc_off is None or desc_off + 20 > len(image):
            continue
        flags = struct.unpack_from("<I", image, desc_off)[0]
        name_rel = struct.unpack_from("<i", image, desc_off + 8)[0]
        field_rel = struct.unpack_from("<i", image, desc_off + 16)[0]
        name = cstring_at_vmaddr(desc_addr + 8 + name_rel) if name_rel else ""
        field_desc_addr = desc_addr + 16 + field_rel if field_rel else 0
        type_descriptors.append((desc_addr, flags, name, field_desc_addr))
        if field_desc_addr in field_descriptors:
            type_associations.append((desc_addr, flags & 0x1F, name, field_desc_addr, field_descriptors[field_desc_addr]))

# For selected nongeneric classes with straightforward trailing metadata, read
# the Swift ABI vtable header and relative implementation pointers. No methods
# are invoked; reported addresses are static metadata only.
symbols = {}
if symtab:
    symoff, nsyms, stroff, strsize = symtab[2], symtab[3], symtab[4], symtab[5]
    if symoff + nsyms * 16 <= len(image) and stroff + strsize <= len(image):
        for idx in range(nsyms):
            strx, ntype, _sect, _desc, value = struct.unpack_from("<IBBHQ", image, symoff + idx * 16)
            if strx == 0 or strx >= strsize or ntype & 0x0E != 0x0E:
                continue
            start = stroff + strx
            end = image.find(b"\0", start, min(stroff + strsize, start + 512))
            if end > start:
                symbols[value] = image[start:end].decode("utf-8", "replace")
symbol_name_hits = [name for name in symbols.values() if re.search(r"MultiPlayer|InternalPlayer|MixingTransitionPlayer|AudioCoordinator", name, re.I)]

vtable_reports = []
selected_types = {"MultiPlayerImpl", "MultiPlayerSessionImpl", "InternalPlayerFactoryImpl",
                  "InternalPlayerImpl", "InternalAudioCoordinator", "MixingTransitionPlayerImpl"}
for desc_addr, flags, name, _field_desc in type_descriptors:
    if name not in selected_types or (flags & 0x1F) != 16:
        continue
    notes = []
    vtable_methods = []
    if not (flags & 0x80000000):
        notes.append("no Swift vtable metadata flag")
    elif flags & 0x80:
        notes.append("generic descriptor; trailing layout not decoded")
    elif flags & (1 << 29):
        notes.append("resilient superclass; trailing layout not decoded")
    elif flags & 0x20:
        notes.append("invertible-protocol trailing metadata; vtable offset not decoded")
    else:
        desc_off = fileoff_for_vmaddr(desc_addr)
        init_kind = (flags >> 16) & 3
        # Swift ABI: singleton initialization contributes three 32-bit
        # relative-pointer fields before the class vtable header.
        if init_kind == 1:
            trailing_init_size = 12
        elif init_kind == 2:
            notes.append("foreign metadata initialization; trailing layout not decoded")
            trailing_init_size = None
        else:
            trailing_init_size = 0
        if desc_off is None or trailing_init_size is None:
            if desc_off is None:
                notes.append("descriptor outside file")
        elif desc_off + 44 + trailing_init_size + 8 > len(image):
            notes.append("descriptor outside file")
        else:
            vt_off = desc_off + 44 + trailing_init_size
            slot_offset, method_count = struct.unpack_from("<II", image, vt_off)
            if method_count > 128 or vt_off + 8 + method_count * 8 > len(image):
                notes.append(f"invalid vtable size {method_count}")
            else:
                for m in range(method_count):
                    method_addr = desc_addr + 52 + trailing_init_size + m * 8
                    method_off = desc_off + 52 + trailing_init_size + m * 8
                    method_flags, impl_rel = struct.unpack_from("<Ii", image, method_off)
                    indirect = bool(impl_rel & 1)
                    impl_addr = method_addr + (impl_rel & ~1 if indirect else impl_rel)
                    if indirect:
                        impl_off = fileoff_for_vmaddr(impl_addr)
                        if impl_off is not None and impl_off + 8 <= len(image):
                            impl_addr = struct.unpack_from("<Q", image, impl_off)[0]
                    vtable_methods.append((m, method_flags, impl_addr, symbols.get(impl_addr, ""), indirect))
                notes.append(f"vtableOffset={slot_offset} entries={method_count}")
    desc_off = fileoff_for_vmaddr(desc_addr)
    raw_descriptor = image[desc_off:desc_off + 72].hex() if desc_off is not None else ""
    vtable_reports.append((desc_addr, flags, name, notes, vtable_methods, raw_descriptor))

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
            elif dest in data_refs:
                hits.append((pc, data_refs[dest], "ADR->[DATA REF]", insn))
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
                elif dest in data_refs:
                    hits.append((pc, data_refs[dest], "ADRP+ADD->[DATA REF]", insn))
                break
            # Resolve common 64-bit LDR literal-through-page sequences.
            for delta in (4, 8, 12, 16):
                if off + delta > end:
                    break
                nxt = struct.unpack_from("<I", image, off + delta)[0]
                if nxt & 0xFFC00000 != 0xF9400000 or ((nxt >> 5) & 31) != rd:
                    continue
                slot = page + (((nxt >> 10) & 0xFFF) * 8)
                if slot in data_refs:
                    hits.append((pc, data_refs[slot], "ADRP+LDR->[DATA REF]", insn))
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
    f.write(f"\nMetadata pointer slots resolving to target strings: {len(data_refs)}\n")
    for slot, target in list(sorted(data_refs.items()))[:200]:
        f.write(f"DATA-REF slot=0x{slot:x} target=0x{target:x} {targets[target]}\n")
    f.write(f"\nSwift field descriptors with targeted field names: {len(field_descriptors)}\n")
    for desc, (owner, kind, fields) in sorted(field_descriptors.items()):
        f.write(f"FIELD-DESCRIPTOR 0x{desc:x} owner={owner!r} kind={kind} fields={fields!r}\n")
    f.write(f"\nSwift type descriptors associated with those field descriptors: {len(type_associations)}\n")
    for desc, kind, name, field_desc, (_owner, _field_kind, fields) in type_associations:
        f.write(f"TYPE-DESCRIPTOR 0x{desc:x} kind={kind} name={name!r} fields=0x{field_desc:x} {fields!r}\n")
    f.write(f"\nSelected Swift class vtables: {len(vtable_reports)}\n")
    f.write(f"\nMach-O symbols in table: {len(symbols)}; player/mixer-named symbols: {len(symbol_name_hits)}\n")
    for sym in symbol_name_hits[:100]:
        f.write(f"SYMBOL {sym}\n")
    for desc, flags, name, notes, methods, raw_descriptor in vtable_reports:
        f.write(f"VTABLE {name} descriptor=0x{desc:x} flags=0x{flags:08x} {'; '.join(notes)} raw={raw_descriptor}\n")
        for idx, mflags, impl, sym, indirect in methods:
            f.write(f"  METHOD[{idx}] flags=0x{mflags:08x} impl=0x{impl:x} indirect={indirect} symbol={sym!r}\n")
    f.write(f"\nDirect code references found: {len(hits)}\n")
    for code, dest, form, raw in hits:
        f.write(f"{form} code=0x{code:x} fileoff=0x{fileoff_for_vmaddr(code):x} target=0x{dest:x} {targets[dest]} insn=0x{raw:08x}\n")
    if not hits:
        f.write("No exact ADR/ADRP+ADD references were found. This is inconclusive: Swift may use relative metadata tables, indirect references, or encrypted code.\n")
print(f"Wrote {out}; strings={len(targets)}, data refs={len(data_refs)}, field descriptors={len(field_descriptors)}, type associations={len(type_associations)}, vtable classes={len(vtable_reports)}, code references={len(hits)}, cryptid={cryptid}", flush=True)
print("----- bounded scan report -----", flush=True)
print(out.read_text(encoding="utf-8")[-20000:], flush=True)

