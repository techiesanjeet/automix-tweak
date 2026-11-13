#!/usr/bin/env python3
"""Inspect Spotify's native transition-player service entry points.

Static analysis only: does not invoke Spotify code or modify the IPA.
"""
import pathlib
import re
import subprocess

root = pathlib.Path.cwd()
apps = list((root / "ipa-work" / "extracted").rglob("Spotify.app"))
if not apps:
    raise SystemExit("Spotify.app not found; run tools/analyze_ipa.py first.")
binary = apps[0] / "Spotify"
if not binary.exists():
    raise SystemExit(f"Spotify executable not found: {binary}")
out = root / "analysis-output"
out.mkdir(exist_ok=True)


def run(args, timeout=300):
    p = subprocess.run(args, stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
                       text=True, errors="replace", timeout=timeout)
    return p.stdout


print("[transition] dumping Objective-C metadata", flush=True)
objc = run(["otool", "-ov", str(binary)], timeout=600)
(out / "spotify-objc-metadata-full.txt").write_text(objc, encoding="utf-8")
lines = objc.splitlines()
terms = [
    "MixingTransitionPlayerImpl", "MixingTransitionPlayerServiceImpl",
    "PlaylistMixing_TransitionPlayerAPI", "MixingCoreAutomixTransitionLoader",
    "SPTServiceSessionDependencyGroupImpl",
]
windows, seen = [], set()
for i, line in enumerate(lines):
    if any(term in line for term in terms):
        lo, hi = max(0, i - 8), min(len(lines), i + 32)
        if (lo, hi) not in seen:
            seen.add((lo, hi))
            windows.append("\n".join(lines[lo:hi]))
(out / "spotify-transition-objc-metadata.txt").write_text(
    "\n\n===== MATCH =====\n\n".join(windows)[:500_000],
    encoding="utf-8")

nm = run(["nm", "-a", str(binary)], timeout=600)
(out / "Spotify.nm.txt").write_text(nm, encoding="utf-8")
targets = {
    "service_init": "0000000107a89760",
    "service_inject_dependencies": "000000010200863c",
    "service_destruct": "000000010194592c",
}

# Verify that the metadata addresses remain present in this exact executable.
for label, address in targets.items():
    if address not in nm:
        raise SystemExit(
            f"Expected IMP address {address} for {label} not found in nm output; "
            "Spotify binary may have changed."
        )

# Apple's otool reliably emits the complete __TEXT,__text assembly listing.
# Filter it locally to a small neighborhood around each IMP; never upload the
# full executable disassembly. Address matching tolerates leading zeroes.
print("[transition] disassembling __TEXT,__text with otool", flush=True)
assembly = run(["otool", "-tvV", str(binary)], timeout=900)
if not assembly.strip():
    raise SystemExit("otool -tvV returned empty output; check runner Xcode tools.")
asm_lines = assembly.splitlines()
address_rows = []
for idx, line in enumerate(asm_lines):
    match = re.match(r"^\s*([0-9a-fA-F]{8,16})\s+(.+)$", line)
    if match:
        address_rows.append((idx, int(match.group(1), 16), line))

sections = []
for label, raw_address in targets.items():
    target = int(raw_address, 16)
    # IMPs may point at an instruction boundary; choose exact or nearest
    # instruction row within 16 bytes, then include 24 rows on either side.
    candidates = [(abs(addr - target), row_idx, addr)
                  for row_idx, addr, _ in address_rows]
    if not candidates:
        sections.append(f"===== {label} ({raw_address}) =====\n"
                        "ERROR: no address-bearing instruction rows parsed.")
        continue
    distance, row_idx, found_addr = min(candidates)
    if distance > 16:
        sections.append(
            f"===== {label} ({raw_address}) =====\n"
            f"ERROR: nearest otool instruction is 0x{found_addr:x} "
            f"(distance {distance} bytes).\n"
            f"Nearby text context: {asm_lines[max(0, row_idx-3):row_idx+4]}"
        )
        continue
    start, stop = max(0, row_idx - 24), min(len(asm_lines), row_idx + 25)
    sections.append(
        f"===== {label} requested=0x{target:x} matched=0x{found_addr:x} "
        f"distance={distance} =====\n" + "\n".join(asm_lines[start:stop])
    )
    print(f"[transition] {label}: matched 0x{found_addr:x} "
          f"(distance {distance} bytes)", flush=True)

result = "\n\n".join(sections)
(out / "spotify-transition-service-disassembly.txt").write_text(
    result[:30_000], encoding="utf-8")

# Follow direct branch-and-link calls from the three service entry points.
# This produces focused callee neighborhoods without dumping the entire binary.
callee_targets = {}
for label, raw_address in targets.items():
    target = int(raw_address, 16)
    candidates = [(abs(addr - target), row_idx, addr)
                  for row_idx, addr, _ in address_rows]
    if not candidates:
        continue
    distance, row_idx, found_addr = min(candidates)
    if distance > 16:
        continue
    # Inspect a modest span around the method's entry; direct BL instructions
    # are candidates only, not asserted semantic matches.
    for line_idx in range(max(0, row_idx - 2),
                          min(len(asm_lines), row_idx + 50)):
        line = asm_lines[line_idx]
        if re.search(r"\bbl\s", line):
            call = re.search(r"\bbl\s+(?:0x)?([0-9a-fA-F]{8,16})", line)
            if call:
                address = int(call.group(1), 16)
                callee_targets.setdefault(address, []).append(
                    f"{label} callsite: {line.strip()}")

callee_sections = []
for target, origins in sorted(callee_targets.items()):
    candidates = [(abs(addr - target), row_idx, addr)
                  for row_idx, addr, _ in address_rows]
    if not candidates:
        continue
    distance, row_idx, found_addr = min(candidates)
    if distance > 16:
        continue
    start, stop = max(0, row_idx - 12), min(len(asm_lines), row_idx + 21)
    callee_sections.append(
        f"===== callee requested=0x{target:x} matched=0x{found_addr:x} "
        f"distance={distance} =====\\n"
        + "\\n".join(origins) + "\\n"
        + "\\n".join(asm_lines[start:stop]))
(out / "spotify-transition-service-callees.txt").write_text(
    "\\n\\n".join(callee_sections)[:100_000], encoding="utf-8")
print(f"[transition] extracted {len(callee_sections)} direct-call callee neighborhoods",
      flush=True)

symbol_names = []
for line in nm.splitlines():
    parts = line.split()
    if len(parts) >= 2 and re.fullmatch(r"[0-9a-fA-F]+", parts[0]):
        symbol_names.append(parts[-1])
print(f"[transition] attempting Swift demangle for {len(symbol_names)} symbols",
      flush=True)
try:
    demangler = run(["xcrun", "--find", "swift-demangle"], timeout=30).strip()
    proc = subprocess.run(
        [demangler], input="\n".join(symbol_names), stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT, text=True, errors="replace", timeout=600
    )
    wanted = re.compile(
        r"PlaylistMixing|MixingTransitionPlayer|MixingPlayingTransitionContext|"
        r"MixingCoreAutomix|AutomixTransition", re.I)
    selected = [line for line in proc.stdout.splitlines() if wanted.search(line)]
    (out / "spotify-transition-swift-symbols.txt").write_text(
        "\n".join(selected) + "\n", encoding="utf-8")
    (out / "swift-demangler-location.txt").write_text(
        demangler + "\n", encoding="utf-8")
    print(f"[transition] relevant demangled symbol lines: {len(selected)}",
          flush=True)
except Exception as e:
    (out / "spotify-transition-swift-symbols.txt").write_text(
        f"Swift demangling failed: {e}\n", encoding="utf-8")

print("Wrote focused otool instruction neighborhoods and metadata.", flush=True)
