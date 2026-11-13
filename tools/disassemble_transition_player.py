#!/usr/bin/env python3
"""Inspect Spotify's native transition-player service entry points.

This is static analysis only. It never invokes Spotify code or modifies the IPA.
"""
import pathlib, subprocess, re, sys

root = pathlib.Path.cwd()
apps = list((root / "ipa-work" / "extracted").rglob("Spotify.app"))
if not apps:
    raise SystemExit("Spotify.app not found; run tools/analyze_ipa.py first.")
app = apps[0]
binary = app / "Spotify"
if not binary.exists():
    raise SystemExit(f"Spotify executable not found: {binary}")
out = root / "analysis-output"
out.mkdir(exist_ok=True)

def run(args, timeout=300):
    p = subprocess.run(args, stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
                       text=True, errors="replace", timeout=timeout)
    return p.stdout

# Objective-C metadata gives the exact IMP addresses and ivar layout for the
# service's visible ObjC thunks.
print("[transition] dumping Objective-C metadata", flush=True)
objc = run(["otool", "-ov", str(binary)], timeout=600)
(out / "spotify-objc-metadata-full.txt").write_text(objc, encoding="utf-8")
lines = objc.splitlines()
terms = [
    "MixingTransitionPlayerImpl", "MixingTransitionPlayerServiceImpl",
    "PlaylistMixing_TransitionPlayerAPI", "MixingCoreAutomixTransitionLoader",
    "SPTServiceSessionDependencyGroupImpl",
]
windows = []
for i, line in enumerate(lines):
    if any(term in line for term in terms):
        lo, hi = max(0, i - 18), min(len(lines), i + 90)
        windows.append("\n".join(lines[lo:hi]))
(out / "spotify-transition-objc-metadata.txt").write_text(
    "\n\n===== MATCH =====\n\n".join(windows), encoding="utf-8")

# Addresses are taken from the IMP entries in the Objective-C metadata and
# independently cross-checked against nm output for this Spotify build.
nm = run(["nm", "-a", str(binary)], timeout=600)
(out / "Spotify.nm.txt").write_text(nm, encoding="utf-8")
targets = {
    "service_init": "0000000107a89760",
    "service_inject_dependencies": "000000010200863c",
    "service_destruct": "000000010194592c",
}
for label, address in targets.items():
    if address not in nm:
        raise SystemExit(f"Expected IMP address {address} for {label} was not found in nm output; binary may have changed.")

# Use Apple's bundled LLVM disassembler with narrow address ranges. The
# extra bytes include prologue/epilogue and nearby branch targets.
dis = []
for label, address in targets.items():
    start = int(address, 16)
    stop = start + (0x180 if label != "service_destruct" else 0x100)
    print(f"[transition] disassembling {label} at {address}", flush=True)
    cmd = [
        "xcrun", "llvm-objdump", "--macho", "--disassemble",
        f"--start-address=0x{start:x}", f"--stop-address=0x{stop:x}",
        str(binary),
    ]
    try:
        result = run(cmd, timeout=180)
    except Exception as e:
        result = f"LLVM DISASSEMBLY ERROR: {e}"
    dis.append(f"===== {label} ({address}) =====\n{result}")
(out / "spotify-transition-service-disassembly.txt").write_text(
    "\n\n".join(dis), encoding="utf-8")

# nm output for this binary may have stripped Swift implementation symbols.
# Still run Apple's bundled demangler against all address-bearing symbol
# names, then retain only any transition/automix-related demangled results.
symbol_names = []
for line in nm.splitlines():
    parts = line.split()
    if len(parts) >= 2 and re.fullmatch(r"[0-9a-fA-F]+", parts[0]):
        symbol_names.append(parts[-1])
print(f"[transition] attempting Swift demangle for {len(symbol_names)} symbols", flush=True)
try:
    demangler = run(["xcrun", "--find", "swift-demangle"], timeout=30).strip()
    proc = subprocess.run(
        [demangler], input="\n".join(symbol_names), stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT, text=True, errors="replace", timeout=600
    )
    demangled = proc.stdout
    wanted = re.compile(r"PlaylistMixing|MixingTransitionPlayer|MixingPlayingTransitionContext|MixingCoreAutomix|AutomixTransition", re.I)
    selected = [line for line in demangled.splitlines() if wanted.search(line)]
    (out / "spotify-transition-swift-symbols.txt").write_text(
        "\n".join(selected) + "\n", encoding="utf-8")
    (out / "swift-demangler-location.txt").write_text(demangler + "\n", encoding="utf-8")
    print(f"[transition] relevant demangled symbol lines: {len(selected)}", flush=True)
except Exception as e:
    (out / "spotify-transition-swift-symbols.txt").write_text(
        f"Swift demangling failed: {e}\n", encoding="utf-8")

print("Wrote transition-player metadata, targeted disassembly, and symbol scan.", flush=True)
