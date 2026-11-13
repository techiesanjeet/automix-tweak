#!/usr/bin/env python3
"""Read Objective-C runtime metadata and disassemble callable IMPs for Spotify mix/player classes.

Static analysis only. Swift-only methods not exposed to the Objective-C runtime
will not appear in Objective-C method lists; the report records that limitation.
"""
import pathlib
import re
import subprocess

ROOT = pathlib.Path.cwd()
apps = list((ROOT / "ipa-work" / "extracted").rglob("Spotify.app"))
if not apps:
    raise SystemExit("Spotify.app not found; run tools/analyze_ipa.py first.")
binary = apps[0] / "Spotify"
if not binary.exists():
    raise SystemExit(f"Spotify executable not found: {binary}")
out = ROOT / "analysis-output"
out.mkdir(exist_ok=True)

TARGETS = re.compile(
    r"MixingTransitionPlayerImpl|MixingTransitionPlayerServiceImpl|"
    r"MixingPlayingTransitionContext|MultiPlayerImpl|InternalPlayerImpl|"
    r"InternalPlayerFactoryImpl|InternalAudioCoordinator",
    re.I,
)

def run(args, timeout=900):
    p = subprocess.run(args, stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
                       text=True, errors="replace", timeout=timeout)
    return p.stdout

print("[objc] dumping Objective-C runtime metadata (otool -ov)", flush=True)
metadata = run(["otool", "-ov", str(binary)], timeout=1200)
if not metadata.strip():
    raise SystemExit("otool -ov returned no Objective-C metadata.")
(out / "spotify-objc-runtime-full.txt").write_text(metadata, encoding="utf-8")
lines = metadata.splitlines()

contexts = []
for i, line in enumerate(lines):
    if TARGETS.search(line):
        start, stop = max(0, i - 35), min(len(lines), i + 150)
        contexts.append((start, stop, line.strip()))

merged = []
seen_ranges = set()
for start, stop, label in contexts:
    key = (start, stop)
    if key not in seen_ranges:
        seen_ranges.add(key)
        merged.append((start, stop, label))

report = [
    "Spotify Objective-C runtime metadata scan",
    f"Binary: {binary}",
    f"Matching class-name contexts: {len(contexts)}",
    "",
]
candidate_imps = set()
for start, stop, label in merged:
    block = lines[start:stop]
    joined = "\n".join(block)
    for m in re.finditer(r"\bimp\s+(?:0x)?([0-9a-fA-F]{8,16})\b", joined):
        candidate_imps.add(int(m.group(1), 16))
    report.append(f"===== Context near: {label} (metadata lines {start+1}-{stop}) =====")
    report.append(joined)
    report.append("")

(out / "spotify-objc-runtime-target-contexts.txt").write_text(
    "\n".join(report), encoding="utf-8")
print(f"[objc] captured {len(merged)} contexts; found {len(candidate_imps)} IMP pointers",
      flush=True)

if not candidate_imps:
    report.append(
        "NO OBJECTIVE-C IMP POINTERS FOUND IN TARGET CONTEXTS.\n"
        "This does not prove the classes have no methods: Swift methods that are "
        "not @objc/dynamically dispatched are absent from Objective-C method lists. "
        "Inspect the full metadata and Swift reflection/symbol data."
    )
    (out / "spotify-objc-imp-disassembly.txt").write_text(
        "\n".join(report), encoding="utf-8")
    print("[objc] no IMPs found; wrote explicit limitation report", flush=True)
    raise SystemExit(0)

print("[objc] disassembling executable text", flush=True)
assembly = run(["otool", "-tvV", str(binary)], timeout=1200)
if not assembly.strip():
    raise SystemExit("otool -tvV returned empty assembly.")
asm_lines = assembly.splitlines()
rows = []
for i, line in enumerate(asm_lines):
    m = re.match(r"^\s*([0-9a-fA-F]{8,16})\s+(.+)$", line)
    if m:
        rows.append((i, int(m.group(1), 16)))
if not rows:
    raise SystemExit("Could not parse address-bearing instruction rows.")

sections = []
for imp in sorted(candidate_imps):
    nearest = min(rows, key=lambda item: abs(item[1] - imp))
    row_idx, found = nearest
    distance = abs(found - imp)
    if distance > 32:
        sections.append(f"IMP 0x{imp:x}: no nearby __text instruction (nearest 0x{found:x}, delta {distance})")
        continue
    start, stop = max(0, row_idx - 8), min(len(asm_lines), row_idx + 100)
    sections.append(
        f"===== Objective-C IMP 0x{imp:x}; nearest instruction 0x{found:x}; delta {distance} =====\n"
        + "\n".join(asm_lines[start:stop])
    )

(out / "spotify-objc-imp-disassembly.txt").write_text(
    "\n\n".join(sections)[:3_000_000], encoding="utf-8")
print(f"[objc] wrote {len(sections)} IMP disassembly reports", flush=True)
