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
    r"createAudioTapWithPlayerItem|enableAudioTap|updateAudioTapForPlayerItem|"
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
    swift = [(a, n) for a, n in raw if n.startswith(("$s", "_$s"))]
    readable_by_name = {}
    if swift:
        demangler = run(["xcrun", "--find", "swift-demangle"], timeout=30).strip()
        if not demangler:
            errors.append(f"{label}: swift-demangle unavailable")
        else:
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

    # Disassemble the selected IMPs in ONE llvm-objdump process.
    # Repeated address-range invocations reparsed the 138 MB Mach-O for every
    # method and exhausted the macOS runner. llvm-objdump supports a comma-
    # separated --disassemble-symbols list, which parses the image once.
    priority_patterns = [
        r"createAudioTapWithPlayerItem", r"updateAudioTapForPlayerItem",
        r"audioTapDidEmitOutput", r"BMPlayerSource.*enableAudioTap",
        r"BMBetamaxPlayerImpl.*enableAudioTap",
        r"BMPlayerSource.*(?:shouldEnableAudioTap|setShouldEnableAudioTap)",
        r"BMPlayerSource.*(?:audioTapFactory|currentPlayerItemChanged)",
        r"BMAudioTap.*(?:initWithPlayerItem|emit|isEnabled|audioTap)",
    ]
    critical = []
    for pattern in priority_patterns:
        critical.extend(n for _, n, readable in matches
                        if re.search(pattern, readable, re.I) and n not in critical)
    selected = list(dict.fromkeys(critical))
    if not selected:
        errors.append(f"{label}: no priority audio-tap symbols matched")
        continue

    # Symbols are the original nm/mangled names; commas cannot occur in the
    # selected Swift/Objective-C symbol names used by these patterns.
    symbol_arg = ",".join(selected)
    try:
        output = run(["xcrun", "llvm-objdump", "--macho",
                      f"--disassemble-symbols={symbol_arg}", str(binary)],
                     timeout=600)
    except subprocess.TimeoutExpired:
        errors.append(f"{label}: single-pass llvm-objdump timed out for {len(selected)} symbols")
        continue
    if not output.strip():
        errors.append(f"{label}: single-pass symbol disassembly returned no output")
        continue

    # Preserve method-specific headings for easier report reading. llvm-objdump
    # prints symbol labels; validate at least one selected raw symbol/address.
    found = [n for n in selected if n in output]
    if not found:
        errors.append(f"{label}: output did not contain any requested symbol labels")
        continue
    all_sections.append(
        f"===== {label}: priority audio-tap lifecycle methods "
        f"({len(found)}/{len(selected)} matched) =====\\n{output[:8_000_000]}")
    print(f"[methods] {label}: disassembled {len(found)}/{len(selected)} priority methods "
          "in one pass; callee expansion deferred", flush=True)

(out / "spotify-multiplayer-method-index.txt").write_text("\n\n".join(all_indexes) + "\n", encoding="utf-8")
(out / "spotify-multiplayer-method-disassembly.txt").write_text(
    "\n\n".join(all_sections)[:12_000_000], encoding="utf-8")
if errors:
    (out / "spotify-multiplayer-methods-error.txt").write_text(
        "\n".join(errors) + "\n", encoding="utf-8")
print(f"[methods] wrote {len(all_sections)} disassembly windows", flush=True)
if not all_sections:
    raise SystemExit("No focused method disassembly windows were produced.")
