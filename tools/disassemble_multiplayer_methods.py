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
    r"createAudioTapWithPlayerItem|enableAudioTap|"
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
    # Preserve Objective-C method symbols verbatim; demangle Swift symbols in batch.
    swift = [(a, n) for a, n in raw if n.startswith(("$s", "_$s"))]
    readable_by_name = {}
    if swift:
        demangler = run(["xcrun", "--find", "swift-demangle"], timeout=30).strip()
        if not demangler:
            errors.append(f"{label}: swift-demangle unavailable")
        else:
            dm = run([demangler, "--compact"], timeout=900) if False else None
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

    print(f"[methods] disassembling {label} __text", flush=True)
    assembly = run(["otool", "-tvV", str(binary)], timeout=1800)
    if not assembly.strip():
        errors.append(f"{label}: otool returned empty assembly")
        continue
    lines = assembly.splitlines()
    rows = []
    for i, line in enumerate(lines):
        m = re.match(r"^\s*([0-9a-fA-F]{8,16})\s+(.+)$", line)
        if m:
            rows.append((i, int(m.group(1), 16)))
    if not rows:
        errors.append(f"{label}: no address-bearing instruction rows")
        continue
    # Address rows are sorted once; binary search avoids repeated O(n) scans
    # for every callback/helper target in very large stripped Mach-O images.
    rows.sort(key=lambda item: item[1])
    row_addresses = [item[1] for item in rows]
    def nearest_row(address):
        pos = bisect.bisect_left(row_addresses, address)
        candidates = rows[max(0, pos - 1):min(len(rows), pos + 1)]
        return min(candidates, key=lambda item: abs(item[1] - address))
    seen = set()

    # Trace direct helper calls made by MultiPlayerAudioTap callbacks in this
    # same Mach-O image. A target is never resolved against the other image.
    callback_symbols = [(a, n, r) for a, n, r in matches
                        if "audioTapDidEmitOutput" in r]
    helper_targets = set()
    for address, name, readable in callback_symbols:
        nearest = nearest_row(address)
        row_idx, found = nearest
        if abs(found - address) > 32:
            continue
        # Inspect the callback's own instruction window and collect direct BLs.
        for asm_line in lines[row_idx:min(len(lines), row_idx + 90)]:
            bm = re.search(r"\bbl\s+(0x[0-9a-fA-F]+)", asm_line)
            if bm:
                target = int(bm.group(1), 16)
                # Keep only in-image calls; external stubs are not helper code.
                if any(target == ins_addr for _, ins_addr in rows):
                    helper_targets.add((target, readable))
    for target, parent in sorted(helper_targets):
        nearest = nearest_row(target)
        row_idx, found = nearest
        if abs(found - target) > 4:
            errors.append(f"{label}: helper target 0x{target:x} not aligned to instruction")
            continue
        # Resolve the closest preceding symbol in this image, for context only.
        preceding = [(a, n, r) for a, n, r in matches if a <= target]
        owner = max(preceding, key=lambda item: item[0]) if preceding else None
        owner_text = f"{owner[2]} @0x{owner[0]:x}" if owner else "stripped/unnamed local helper"
        start, stop = max(0, row_idx - 8), min(len(lines), row_idx + 180)
        all_sections.append(
            f"===== {label}: helper for {parent} =====\n"
            f"image={binary.name} target=0x{target:x} owner={owner_text}\n"
            + "\n".join(lines[start:stop]))
    # Trace one additional call layer from callback helpers. This is deliberately
    # bounded: it disassembles direct in-image callees only, not a recursive graph.
    second_level = set()
    for target, parent in sorted(helper_targets):
        nearest = nearest_row(target)
        row_idx, found = nearest
        if abs(found - target) > 4:
            continue
        for asm_line in lines[row_idx:min(len(lines), row_idx + 180)]:
            bm = re.search(r"\bbl\s+(0x[0-9a-fA-F]+)", asm_line)
            if not bm:
                continue
            callee = int(bm.group(1), 16)
            # Ignore runtime/stub targets; focus on private in-image routines.
            if callee < 0x100000000 or callee >= 0x109b00000:
                continue
            if any(callee == ins_addr for _, ins_addr in rows):
                second_level.add((callee, target, parent))
    # Trace one more bounded layer from those callees. This is needed when a
    # callback helper delegates field decoding/conversion to small leaf routines.
    # callback helper delegates field decoding/conversion to small leaf routines.
    third_level = set()
    for callee, caller, parent in sorted(second_level):
        nearest = nearest_row(callee)
        row_idx, found = nearest
        if abs(found - callee) > 4:
            continue
        for asm_line in lines[row_idx:min(len(lines), row_idx + 180)]:
            bm = re.search(r"\bbl\s+(0x[0-9a-fA-F]+)", asm_line)
            if not bm:
                continue
            leaf = int(bm.group(1), 16)
            if leaf < 0x100000000 or leaf >= 0x109b00000:
                continue
            if any(leaf == ins_addr for _, ins_addr in rows):
                third_level.add((leaf, callee, parent))
    for leaf, caller, parent in sorted(third_level):
        nearest = nearest_row(leaf)
        row_idx, found = nearest
        if abs(found - leaf) > 4:
            continue
        start, stop = max(0, row_idx - 8), min(len(lines), row_idx + 120)
        all_sections.append(
            f"===== {label}: third-level leaf of 0x{caller:x} for {parent} =====\n"
            f"image={binary.name} target=0x{leaf:x}\n"
            + "\n".join(lines[start:stop]))

    for callee, caller, parent in sorted(second_level):
        nearest = nearest_row(callee)
        row_idx, found = nearest
        if abs(found - callee) > 4:
            continue
        start, stop = max(0, row_idx - 8), min(len(lines), row_idx + 140)
        all_sections.append(
            f"===== {label}: second-level callee of 0x{caller:x} for {parent} =====\n"
            f"image={binary.name} target=0x{callee:x}\n"
            + "\n".join(lines[start:stop]))

    for address, name, readable in matches:
        # Binary search would be faster, but this list is modest after filtering.
        nearest = nearest_row(address)
        row_idx, found = nearest
        distance = abs(found - address)
        if distance > 32:
            continue
        start, stop = max(0, row_idx - 8), min(len(lines), row_idx + 121)
        key = (start, stop)
        if key in seen:
            continue
        seen.add(key)
        all_sections.append(
            f"===== {label}: {readable} =====\n"
            f"symbol=0x{address:x} matched=0x{found:x} distance={distance}\n"
            + "\n".join(lines[start:stop]))

(out / "spotify-multiplayer-method-index.txt").write_text(
    "\n\n".join(all_indexes) + "\n", encoding="utf-8")
(out / "spotify-multiplayer-method-disassembly.txt").write_text(
    "\n\n".join(all_sections)[:8_000_000], encoding="utf-8")
if errors:
    (out / "spotify-multiplayer-methods-error.txt").write_text(
        "\n".join(errors) + "\n", encoding="utf-8")
print(f"[methods] wrote {len(all_sections)} disassembly windows", flush=True)
if not all_sections:
    raise SystemExit("No focused method disassembly windows were produced.")
