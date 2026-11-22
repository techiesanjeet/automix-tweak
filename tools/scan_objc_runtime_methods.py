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

# The audio-tap gate sends the generic Objective-C selector "status" to
# the current player-item object and requires the returned integer to equal 1.
# Capture every runtime-metadata context for this exact selector pointer so
# we can identify candidate owning classes instead of guessing from its name.
status_pointer = "0x10ba450e0"
status_hits = []
for i, line in enumerate(lines):
    if re.search(r"^\s*name\s+" + re.escape(status_pointer) + r"\s+status\s*$", line):
        start, stop = max(0, i - 24), min(len(lines), i + 36)
        status_hits.append((start, stop, line.strip()))
status_report = [
    "Exact Objective-C selector metadata contexts for status",
    f"Selector pointer: {status_pointer}",
    "The callsite applies this selector to the player-item argument; class ownership remains to be confirmed.",
    f"Matching metadata entries: {len(status_hits)}",
    "",
]
for n, (start, stop, label) in enumerate(status_hits, 1):
    status_report.append(f"===== status metadata hit {n} (lines {start+1}-{stop}) =====")
    status_report.extend(lines[start:stop])
    status_report.append("")
(out / "spotify-status-selector-contexts.txt").write_text(
    "\n".join(status_report), encoding="utf-8")
print(f"[objc] captured {len(status_hits)} exact status-selector contexts", flush=True)

# In this Mach-O, method-list entries use a relative name pointer for the
# selector string "status" (resolved by otool as 0x10d2b45c0), while ivar and
# property metadata use the separate selector pointer above. Keep these
# method-list hits distinct and capture their enclosing class/protocol owners.
status_method_name_address = "0x10d2b45c0"
method_hits = []
for i, line in enumerate(lines):
    if status_method_name_address in line and re.search(r"^\s*name\s+.*\(", line):
        start, stop = max(0, i - 30), min(len(lines), i + 5)
        method_hits.append((start, stop, line.strip()))
method_report = [
    "Objective-C method-list entries for the status selector string",
    f"Resolved method-name address: {status_method_name_address}",
    f"Matching method-list entries: {len(method_hits)}",
    "Each context includes the nearest enclosing class/protocol and method type/IMP when present.",
    "",
]
for n, (start, stop, label) in enumerate(method_hits, 1):
    method_report.append(f"===== status method entry {n} (lines {start+1}-{stop}) =====")
    method_report.extend(lines[start:stop])
    method_report.append("")
(out / "spotify-status-method-list-owners.txt").write_text(
    "\\n".join(method_report), encoding="utf-8")
print(f"[objc] captured {len(method_hits)} status method-list entries", flush=True)

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
    "\n".join(imp_rows) + "\\n", encoding="utf-8")
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
