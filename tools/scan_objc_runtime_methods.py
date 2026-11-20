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
    r"_TtC22MultiPlayer_PlayerImpl(?:24InternalAudioCoordinator|"
    r"25InternalPlayerFactoryImpl|18InternalPlayerImpl|15MultiPlayerImpl|"
    r"19MultiPlayerAudioTap)\b|"
    r"_TtC35PlaylistMixing_TransitionPlayerImpl(?:26MixingTransitionPlayerImpl|"
    r"33MixingTransitionPlayerServiceImpl)\b|"
    r"(?:BMAudioTapFactory|BMAudioTap|BMBetamaxPlayerImpl|BMPlayerSource)\b",
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
    for m in re.finditer(
        r"\bimp\s+(?:0x)?([0-9a-fA-F]{8,16})\s+\((?:0x)?([0-9a-fA-F]{8,16})\)",
        joined
    ):
        # otool prints the raw chained-fixup value first and the resolved
        # unslid virtual address in parentheses. Disassemble the latter.
        candidate_imps.add(int(m.group(2), 16))
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

print("[objc] disassembling only target IMP windows (avoids whole-binary otool dump)", flush=True)
# A full `otool -tvV` dump of Spotify is extremely slow (the previous run
# spent >22 minutes here and was cancelled). Use Apple's LLVM objdump on
# small address windows around each IMP instead.
objdump = ["xcrun", "llvm-objdump", "--macho", "--disassemble"]
sections = []
for n, imp in enumerate(sorted(candidate_imps), 1):
    start_addr = max(0, imp - 32)
    stop_addr = imp + 384
    cmd = objdump + [f"--start-address=0x{start_addr:x}",
                     f"--stop-address=0x{stop_addr:x}", str(binary)]
    try:
        chunk = run(cmd, timeout=30)
    except (subprocess.TimeoutExpired, FileNotFoundError) as exc:
        raise SystemExit(f"Targeted llvm-objdump failed at IMP 0x{imp:x}: {exc}")
    if not chunk.strip() or "error:" in chunk.lower():
        sections.append(f"===== IMP 0x{imp:x}: disassembly unavailable =====\\n{chunk[:2000]}")
    else:
        sections.append(f"===== Objective-C IMP 0x{imp:x} (window 0x{start_addr:x}-0x{stop_addr:x}) =====\\n{chunk}")
    if n % 25 == 0:
        print(f"[objc] disassembled {n}/{len(candidate_imps)} IMP windows", flush=True)

(out / "spotify-objc-imp-disassembly.txt").write_text(
    "\\n\\n".join(sections)[:3_000_000], encoding="utf-8")
print(f"[objc] wrote {len(sections)} targeted IMP windows", flush=True)
