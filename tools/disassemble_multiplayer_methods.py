#!/usr/bin/env python3
"""Disassemble multiplayer methods across Spotify and SpotifyShared.

Read-only static analysis. Does not modify or execute Spotify.
"""
import bisect
import pathlib
import re
import subprocess

ROOT = pathlib.Path.cwd()
apps = list((ROOT / "ipa-work" / "extracted").rglob("Spotify.app"))
if not apps:
    raise SystemExit("Spotify.app not found; run tools/analyze_ipa.py first.")
app = apps[0]
binaries = [("Spotify", app / "Spotify"),
            ("SpotifyShared", app / "Frameworks" / "SpotifyShared.framework" / "SpotifyShared")]
out = ROOT / "analysis-output"
out.mkdir(exist_ok=True)

FOCUS = re.compile(
    r"MultiPlayerImpl|InternalPlayerImpl|InternalPlayerFactoryImpl|"
    r"InternalAudioCoordinator|MixingTransitionPlayerImpl|GenericPlayerPool|"
    r"SinglePlayerImpl|PlayerGroupImpl|MultiPlayerSessionImpl|"
    r"MultiPlayerAudioTap|BMAudioTap|audioTapDidEmitOutput|"
    r"createAudioTapWithPlayerItem|enableAudioTap|updateAudioTapForPlayerItem|"
    r"BMPlayerSource.*(?:setShouldEnableAudioTap|shouldEnableAudioTap|"
    r"audioTapFactory|audioTap|currentPlayerItemChanged|initWithPlayerConfiguration)|"
    r"BMBetamaxPlayerImpl.*initWithPlaybackSessionFactory",
    re.I,
)
EXCLUDE = ("metadata", "type metadata", "nominal type descriptor",
           "protocol conformance", "witness table", "field offset")

def run(args, *, timeout=1200):
    p = subprocess.run(args, stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
                       text=True, errors="replace", timeout=timeout)
    return p.stdout

all_indexes, all_sections, errors = [], [], []
for label, binary in binaries:
    if not binary.exists():
        errors.append(f"{label}: binary missing: {binary}")
        continue
    print(f"[methods] collecting {label} symbols", flush=True)
    nm_text = run(["nm", "-a", str(binary)], timeout=600)
    raw = []
    for line in nm_text.splitlines():
        parts = line.split()
        if len(parts) >= 2 and re.fullmatch(r"[0-9a-fA-F]{8,16}", parts[0]):
            raw.append((int(parts[0], 16), " ".join(parts[2:])))

    matches = []
    swift = [(a, n) for a, n in raw if n.startswith(("$s", "_$s"))]
    readable_by_name = {}
    if swift:
        demangler = run(["xcrun", "--find", "swift-demangle"], timeout=30).strip()
        if not demangler:
            errors.append(f"{label}: swift-demangle unavailable")
        else:
            proc = subprocess.run([demangler, "--compact"],
                input="\n".join(n for _, n in swift), stdout=subprocess.PIPE,
                stderr=subprocess.STDOUT, text=True, errors="replace", timeout=900)
            vals = proc.stdout.splitlines()
            if len(vals) == len(swift):
                readable_by_name.update({n: v for (_, n), v in zip(swift, vals)})
            else:
                errors.append(f"{label}: demangle count mismatch {len(swift)} vs {len(vals)}")

    for address, name in raw:
        readable = readable_by_name.get(name, name)
        if FOCUS.search(readable) and not any(x in readable for x in EXCLUDE):
            matches.append((address, name, readable))

    all_indexes.append(f"===== {label} =====\n" + "\n\n".join(
        f"0x{a:016x}  {n}\n    {r}" for a, n, r in matches))
    print(f"[methods] {label}: {len(matches)} candidate symbols", flush=True)
    if not matches:
        continue

    # Disassemble only matched symbols. Full `otool -tvV` output for
    # Spotify is hundreds of MB and needlessly parses unrelated code.
    symbol_by_address = {a: n for a, n in raw}
    # Prioritize the PCM-tap lifecycle methods. The previous broad alphabetical
    # batch filled the 12 MB report cap with unrelated multiplayer symbols.
    priority_patterns = [
        r"createAudioTapWithPlayerItem", r"updateAudioTapForPlayerItem",
        r"audioTapDidEmitOutput", r"BMPlayerSource.*enableAudioTap",
        r"BMBetamaxPlayerImpl.*enableAudioTap",
        r"BMPlayerSource.*(?:shouldEnableAudioTap|setShouldEnableAudioTap)",
        r"BMPlayerSource.*(?:audioTapFactory|currentPlayerItemChanged)",
        r"BMAudioTap.*(?:initWithPlayerItem|emit|isEnabled|audioTap)",
    ]
    critical = []
    for pattern in priority_patterns:
        critical.extend(n for _, n, readable in matches
                        if re.search(pattern, readable, re.I) and n not in critical)
    selected = list(critical)

    # Objective-C selector methods often exist only in the runtime method
    # list, not as Mach-O symbols. Disassemble by the IMP address from nm.
    sorted_addresses = sorted(a for a, _ in raw)
    match_by_name = {name: (address, readable)
                     for address, name, readable in matches}
    def disassemble_symbols(names):
        chunks = []
        for name in dict.fromkeys(names):
            item = match_by_name.get(name)
            if not item:
                continue
            address, readable = item
            next_addresses = [a for a in sorted_addresses if a > address]
            # Bound each window to the next known symbol, with a conservative
            # maximum to avoid dumping unrelated neighboring functions.
            stop = min(next_addresses[0] if next_addresses else address + 0x400,
                       address + 0x800)
            output = run(["xcrun", "llvm-objdump", "--macho", "--disassemble",
                          f"--start-address=0x{address:x}",
                          f"--stop-address=0x{stop:x}", str(binary)], timeout=120)
            if output.strip():
                chunks.append(f"===== {name} ({readable}) @ 0x{address:x} =====\\n{output}")
        return "\\n".join(chunks)

    first = disassemble_symbols(selected)
    if not first.strip():
        errors.append(f"{label}: address-bounded llvm-objdump returned no output")
        continue
    expected_addresses = [match_by_name[n][0] for n in selected if n in match_by_name]
    if not any(f"0x{address:x}" in first for address in expected_addresses):
        errors.append(f"{label}: address-bounded disassembly did not include requested IMP addresses")
        continue
    all_sections.append(f"===== {label}: priority audio-tap lifecycle methods =====\\n{first}")

    # Follow direct calls through a bounded number of named helper symbols.
    known_addresses = set(symbol_by_address)
    selected_set = set(selected)
    frontier = []
    for line in first.splitlines():
        bm = re.search(r"\bbl\s+(?:0x)?([0-9a-fA-F]{8,16})", line)
        if bm:
            address = int(bm.group(1), 16)
            if address in known_addresses:
                name = symbol_by_address[address]
                if name not in selected_set and name not in frontier:
                    frontier.append(name)
    for level in (2, 3):
        frontier = [n for n in frontier if n not in selected_set][:80]
        if not frontier:
            break
        helper_output = disassemble_symbols(frontier)
        if not helper_output.strip():
            errors.append(f"{label}: no output for level-{level} named callees")
            break
        all_sections.append(
            f"===== {label}: level-{level} named callees =====\\n{helper_output}")
        selected_set.update(frontier)
        next_frontier = []
        for line in helper_output.splitlines():
            bm = re.search(r"\bbl\s+(?:0x)?([0-9a-fA-F]{8,16})", line)
            if bm:
                address = int(bm.group(1), 16)
                if address in known_addresses:
                    name = symbol_by_address[address]
                    if name not in selected_set and name not in next_frontier:
                        next_frontier.append(name)
        frontier = next_frontier
    print(f"[methods] {label}: emitted {len(selected)} priority methods and "
          f"{len(selected_set)-len(selected)} bounded callees", flush=True)

(out / "spotify-multiplayer-method-index.txt").write_text(
    "\n\n".join(all_indexes) + "\n", encoding="utf-8")
(out / "spotify-multiplayer-method-disassembly.txt").write_text(
    "\n\n".join(all_sections)[:12_000_000], encoding="utf-8")
if errors:
    (out / "spotify-multiplayer-methods-error.txt").write_text(
        "\n".join(errors) + "\n", encoding="utf-8")
print(f"[methods] wrote {len(all_sections)} disassembly windows", flush=True)
if not all_sections:
    raise SystemExit("No focused method disassembly windows were produced.")
