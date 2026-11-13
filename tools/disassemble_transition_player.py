#!/usr/bin/env python3
"""Targeted disassembly of Spotify's native playlist transition-player wiring."""
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

# Preserve full ObjC metadata output, then extract small windows around the
# transition-player classes and the dependency-injection service.
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
        lo, hi = max(0, i - 18), min(len(lines), i + 65)
        windows.append("\n".join(lines[lo:hi]))
(out / "spotify-transition-objc-metadata.txt").write_text(
    "\n\n===== MATCH =====\n\n".join(windows), encoding="utf-8")

# These are the only Objective-C entry points exposed by the transition
# service in the symbol table. Disassemble their exact symbol names.
symbols = [
    "-[_TtC35PlaylistMixing_TransitionPlayerImpl33MixingTransitionPlayerServiceImpl init]",
    "-[_TtC35PlaylistMixing_TransitionPlayerImpl33MixingTransitionPlayerServiceImpl _injectDependenciesWithProvider:]",
    "-[_TtC35PlaylistMixing_TransitionPlayerImpl33MixingTransitionPlayerServiceImpl .cxx_destruct]",
]
dis = []
for symbol in symbols:
    print("[transition] disassembling " + symbol, flush=True)
    try:
        result = run(["otool", "-tvV", "-p", symbol, str(binary)], timeout=180)
    except Exception as e:
        result = f"DISASSEMBLY ERROR: {e}"
    dis.append("===== " + symbol + " =====\n" + result)
(out / "spotify-transition-service-disassembly.txt").write_text(
    "\n\n".join(dis), encoding="utf-8")

# Capture the toolchain demangler location/version so follow-up work knows
# whether Swift ABI symbols can be decoded on this runner.
try:
    tool = run(["xcrun", "--find", "swift-demangle"], timeout=30).strip()
except Exception as e:
    tool = f"xcrun lookup failed: {e}"
(out / "swift-demangler-location.txt").write_text(tool + "\n", encoding="utf-8")
print("Wrote targeted transition-player disassembly outputs.", flush=True)
