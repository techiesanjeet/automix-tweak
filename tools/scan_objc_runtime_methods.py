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

# Do not invoke a second disassembler here. The preceding
# disassemble_multiplayer_methods.py step already disassembles the relevant
# named methods from the symbol table. Running llvm-objdump separately for
# every IMP repeatedly reparses the 138 MB Mach-O and times out even for
# tiny address windows. Preserve the runtime IMP map for cross-referencing
# with spotify-multiplayer-method-disassembly.txt instead.
imp_rows = [
    f"0x{imp:x}"
    for imp in sorted(candidate_imps)
]
(out / "spotify-objc-imp-addresses.txt").write_text(
    "\\n".join(imp_rows) + "\\n", encoding="utf-8")
summary = [
    "Objective-C IMP address inventory",
    f"Unique IMP addresses: {len(candidate_imps)}",
    "Disassembly is provided by spotify-multiplayer-method-disassembly.txt "
    "for named symbols; this scanner intentionally avoids a duplicate "
    "whole-binary or per-IMP disassembly pass.",
    "",
    *imp_rows,
]
(out / "spotify-objc-imp-disassembly.txt").write_text(
    "\\n".join(summary), encoding="utf-8")
print(f"[objc] wrote {len(candidate_imps)} IMP addresses; using existing named-method disassembly", flush=True)
