#!/usr/bin/env python3
"""Find and disassemble Swift methods for Spotify's multiplayer playback classes.

Read-only static analysis. Does not modify or execute Spotify.
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

CLASSES = re.compile(
    r"MultiPlayer_PlayerImpl.*(?:MultiPlayerImpl|InternalPlayerImpl|"
    r"InternalPlayerFactoryImpl|InternalAudioCoordinator)|"
    r"PlaylistMixing_TransitionPlayerImpl.*MixingTransitionPlayerImpl|"
    r"MixingTransitionPlayerImpl",
    re.I,
)
# Keep the search narrow: these are the classes that own player creation,
# playback state, audio coordination, and playlist transition orchestration.
FOCUS = re.compile(
    r"MultiPlayerImpl|InternalPlayerImpl|InternalPlayerFactoryImpl|"
    r"InternalAudioCoordinator|MixingTransitionPlayerImpl",
    re.I,
)

def run(args, *, input_text=None, timeout=900):
    p = subprocess.run(args, input=input_text, stdout=subprocess.PIPE,
                       stderr=subprocess.STDOUT, text=True, errors="replace",
                       timeout=timeout)
    return p.stdout

print("[methods] collecting Spotify symbols", flush=True)
nm_text = run(["nm", "-a", str(binary)], timeout=600)
raw = []
for line in nm_text.splitlines():
    parts = line.split()
    if len(parts) >= 2 and re.fullmatch(r"[0-9a-fA-F]{8,16}", parts[0]):
        raw.append((int(parts[0], 16), parts[-1]))

try:
    demangler = run(["xcrun", "--find", "swift-demangle"], timeout=30).strip()
    if not demangler or not pathlib.Path(demangler).exists():
        raise RuntimeError("xcrun did not locate swift-demangle")
    # --compact emits one demangled result per input symbol, preserving order.
    demangled_text = run([demangler, "--compact"],
                         input_text="\n".join(name for _, name in raw),
                         timeout=900)
    demangled = demangled_text.splitlines()
    if len(demangled) != len(raw):
        raise RuntimeError(
            f"symbol/demangle count mismatch: {len(raw)} raw vs "
            f"{len(demangled)} demangled lines"
        )
except Exception as exc:
    (out / "spotify-multiplayer-methods-error.txt").write_text(
        f"Swift demangling unavailable: {exc}\n", encoding="utf-8")
    raise SystemExit(f"Could not demangle Spotify Swift symbols: {exc}")

matches = []
for (address, mangled), readable in zip(raw, demangled):
    if FOCUS.search(readable) and not any(x in readable for x in
            ("metadata", "type metadata", "nominal type descriptor",
             "protocol conformance", "witness table", "field offset")):
        matches.append((address, mangled, readable))

# Preserve a compact symbol-to-address index for review and future hook work.
index_lines = [
    f"0x{address:016x}  {mangled}\n    {readable}"
    for address, mangled, readable in matches
]
(out / "spotify-multiplayer-method-index.txt").write_text(
    "\n\n".join(index_lines) + "\n", encoding="utf-8")
print(f"[methods] found {len(matches)} candidate method symbols", flush=True)

if not matches:
    raise SystemExit("No candidate method symbols found; inspect the method index.")

print("[methods] disassembling Spotify __text", flush=True)
assembly = run(["otool", "-tvV", str(binary)], timeout=1200)
if not assembly.strip():
    raise SystemExit("otool returned empty assembly.")
lines = assembly.splitlines()
rows = []
for i, line in enumerate(lines):
    m = re.match(r"^\\s*([0-9a-fA-F]{8,16})\\s+(.+)$", line)
    if m:
        rows.append((i, int(m.group(1), 16)))

if not rows:
    raise SystemExit("Could not parse address-bearing otool instruction rows.")

sections = []
seen = set()
for address, mangled, readable in matches:
    nearest = min(rows, key=lambda item: abs(item[1] - address))
    row_idx, found = nearest
    distance = abs(found - address)
    if distance > 32:
        continue
    # A method's start may be preceded by a compact Swift prologue. Keep 8
    # instructions before and 80 after the symbol start, capped per method.
    start, stop = max(0, row_idx - 8), min(len(lines), row_idx + 81)
    key = (start, stop)
    if key in seen:
        continue
    seen.add(key)
    sections.append(
        f"===== {readable} =====\n"
        f"symbol=0x{address:x} matched=0x{found:x} distance={distance}\n"
        + "\n".join(lines[start:stop])
    )

(out / "spotify-multiplayer-method-disassembly.txt").write_text(
    "\n\n".join(sections)[:2_000_000], encoding="utf-8")
print(f"[methods] wrote {len(sections)} focused disassembly windows", flush=True)
