#!/usr/bin/env python3
"""Trace direct callees of Spotify's confirmed transition service IMPs.

Static analysis only. The targets are the IMPs recovered from Objective-C
runtime metadata in the current Spotify executable.
"""
import pathlib
import re
import subprocess

ROOT = pathlib.Path.cwd()
apps = list((ROOT / "ipa-work" / "extracted").rglob("Spotify.app"))
if not apps:
    raise SystemExit("Spotify.app not found; run tools/analyze_ipa.py first.")
binary = apps[0] / "Spotify"
out = ROOT / "analysis-output"
out.mkdir(exist_ok=True)

METHODS = {
    0x10200863c: "MixingTransitionPlayerServiceImpl._injectDependenciesWithProvider:",
    0x107a89760: "MixingTransitionPlayerServiceImpl.init",
    0x10194592c: "MixingTransitionPlayerServiceImpl .cxx_destruct",
}

def run(args, timeout=1200):
    p = subprocess.run(args, stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
                       text=True, errors="replace", timeout=timeout)
    return p.stdout

print("[trace] disassembling Spotify executable", flush=True)
asm = run(["otool", "-tvV", str(binary)])
if not asm.strip():
    raise SystemExit("otool -tvV returned empty assembly.")
lines = asm.splitlines()
rows = []
for i, line in enumerate(lines):
    m = re.match(r"^\s*([0-9a-fA-F]{8,16})\s+(.+)$", line)
    if m:
        rows.append((i, int(m.group(1), 16), m.group(2)))

if not rows:
    raise SystemExit("Could not parse instruction addresses.")

def nearest_index(address):
    return min(range(len(rows)), key=lambda n: abs(rows[n][1] - address))

# Use nm's function symbols to bound each method rather than accidentally
# treating adjacent compiler-generated functions as part of the same method.
nm_text = run(["nm", "-nm", str(binary)])
symbols = []
for line in nm_text.splitlines():
    m = re.match(r"^([0-9a-fA-F]{8,16})\s+[tT]\s+(.+)$", line.strip())
    if m:
        symbols.append((int(m.group(1), 16), m.group(2)))
symbols.sort()

def method_end(address):
    for symbol_address, _ in symbols:
        if symbol_address > address:
            return symbol_address
    return address + 0x300

# Exact service methods and their immediate BL targets.
targets = set()
report = ["Spotify transition service direct-call trace", ""]
for address, label in METHODS.items():
    idx = nearest_index(address)
    row_idx, found, _ = rows[idx]
    if found != address:
        report.append(f"WARNING: {label}: requested 0x{address:x}, nearest 0x{found:x}")
    end_address = method_end(address)
    stop = idx
    while stop < len(rows) and rows[stop][1] < end_address:
        stop += 1
    stop = max(idx + 1, stop)
    start = max(0, idx - 2)
    window = rows[start:stop]
    calls = set()
    for _, _, insn in window:
        m = re.search(r"\bbl\s+(?:0x)?([0-9a-fA-F]{8,16})", insn)
        if m:
            calls.add(int(m.group(1), 16))
    report.append(f"===== {label} @ 0x{address:x}; end 0x{end_address:x} =====")
    report.extend(lines[max(0, row_idx - 2):min(len(lines), rows[stop-1][0] + 1)])
    report.append("Direct BL targets: " + ", ".join(f"0x{x:x}" for x in sorted(calls)))
    report.append("")
    targets.update(calls)

# Include direct callees that appear to be executable addresses, excluding
# known system/runtime stubs only by address range (the disassembly will tell).
for target in sorted(targets):
    idx = nearest_index(target)
    row_idx, found, _ = rows[idx]
    distance = abs(found - target)
    if distance > 16:
        report.append(f"===== Callee 0x{target:x}: no nearby instruction (nearest 0x{found:x}) =====")
        continue
    start, stop = max(0, idx - 5), min(len(rows), idx + 100)
    report.append(f"===== Direct callee 0x{target:x} (nearest 0x{found:x}) =====")
    report.extend(lines[rows[start][0]:rows[stop-1][0] + 1])
    report.append("")

path = out / "spotify-transition-service-call-trace.txt"
path.write_text("\n".join(report)[:8_000_000], encoding="utf-8")
print(f"[trace] wrote {path} with {len(targets)} unique direct call targets", flush=True)
