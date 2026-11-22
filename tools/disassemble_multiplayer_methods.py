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

    # Stream the Mach-O disassembly once and retain only selected IMP ranges.
    # --disassemble-symbols has inconsistent matching for Swift-mangled names
    # on the Apple LLVM toolchain. Streaming avoids capturing the full output.
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
        critical.extend((a, n, readable) for a, n, readable in matches
                        if re.search(pattern, readable, re.I))
    # Keep unique IMPs, not duplicate symbol aliases.
    selected_by_address = {}
    for address, name, readable in critical:
        selected_by_address.setdefault(address, (name, readable))
    selected = sorted((a, n, r) for a, (n, r) in selected_by_address.items())
    if not selected:
        errors.append(f"{label}: no priority audio-tap symbols matched")
        continue

    all_addresses = sorted(set(a for a, _ in raw))
    ranges = []
    for address, name, readable in selected:
        # Symbol tables contain local labels only a few bytes after a method
        # start; do not let those truncate the method window.
        stop = address + 0x600
        ranges.append((address, stop, name, readable))

    # BMBetamaxPlayerImpl -[enableAudioTap:] is a forwarding thunk. Capture
    # its internal BL/tail-branch targets as separate address windows so the
    # actual gate/dispatch work is not missed merely because nm has no local
    # symbol names for these compiler-generated helpers.
    if label == "Spotify":
        helper_targets = [
            (0x107c9f2c0, "enableAudioTap helper 1"),
            (0x107ca7024, "enableAudioTap helper 2"),
            (0x107c8ec2c, "enableAudioTap helper 3"),
            (0x107c9b4a8, "enableAudioTap helper 4"),
            (0x107c8ebf4, "enableAudioTap tail target"),
            (0x109bad7c0, "updateAudioTap helper bool (stub entry)"),
            (0x109bb0f88, "updateAudioTap helper constant (stub entry)"),
            # The four enableAudioTap branch destinations above are linker
            # stubs. Follow their branch instructions to the implementation
            # addresses observed in this binary's stub table.
            (0x109b9588c, "enableAudioTap resolved helper 1"),
            (0x109afc058, "enableAudioTap resolved helper 3"),
            (0x109b79dac, "enableAudioTap resolved helper 4"),
            (0x109afbfa0, "enableAudioTap resolved tail target"),
        ]
        existing = {start for start, _, _, _ in ranges}
        for address, description in helper_targets:
            if address not in existing:
                ranges.append((address, address + 0x300, description,
                               "compiler-generated helper target (address-derived)"))
        ranges.sort(key=lambda item: item[0])

    print(f"[methods] {label}: streaming disassembly for {len(ranges)} IMP/helper ranges", flush=True)
    proc = subprocess.Popen(
        ["xcrun", "llvm-objdump", "--macho", "--disassemble", str(binary)],
        stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
        text=True, errors="replace", bufsize=1)
    captured = {address: [] for address, _, _, _ in ranges}
    range_starts = [item[0] for item in ranges]
    address_re = re.compile(r"(?:0x)?([0-9a-fA-F]{8,16}):")
    sample_lines = []
    parsed_addresses = 0
    # Sweep the monotonically increasing objdump stream with an active interval
    # set. A later, short helper window may expire before an earlier, longer
    # method window; stopping at the first expired interval loses the earlier
    # overlap. Keep every live interval until its own stop address.
    next_range = 0
    active_ranges = []
    try:
        for line in proc.stdout:
            if len(sample_lines) < 24:
                sample_lines.append(line.rstrip())
            match = address_re.search(line)
            if not match:
                continue
            parsed_addresses += 1
            instruction_address = int(match.group(1), 16)
            while (next_range < len(ranges) and
                   ranges[next_range][0] <= instruction_address):
                active_ranges.append(next_range)
                next_range += 1
            active_ranges = [idx for idx in active_ranges
                             if ranges[idx][1] > instruction_address]
            for idx in active_ranges:
                begin, stop, name, readable = ranges[idx]
                captured[begin].append(line.rstrip())
        return_code = proc.wait(timeout=600)
    except Exception:
        proc.kill()
        proc.wait()
        raise
    emitted = 0
    for begin, stop, name, readable in ranges:
        lines = captured[begin]
        if lines:
            all_sections.append(
                f"===== {label}: {name} ({readable}) @ 0x{begin:x} =====\\n" +
                "\\n".join(lines))
            emitted += 1
    print(f"[methods] {label}: parsed {parsed_addresses} instruction addresses; "
          f"sample={sample_lines[:8]}", flush=True)
    if return_code != 0:
        errors.append(f"{label}: llvm-objdump exited {return_code}")
    if label == "Spotify":
        # Direct bounded disassembly for gate helpers omitted by the broad
        # symbol sweep. These two call targets decide whether tap setup runs.
        for target, description in [
            (0x109bad7c0, "updateAudioTap gate helper 1"),
            (0x109bb0f88, "updateAudioTap gate helper 2"),
        ]:
            direct = run([
                "xcrun", "llvm-objdump", "--macho", "--disassemble",
                f"--start-address=0x{target:x}",
                f"--stop-address=0x{target + 0x100:x}", str(binary)
            ], timeout=120)
            all_sections.append(
                f"===== {label}: {description} (direct address disassembly) @ 0x{target:x} =====\\n"
                + direct.strip())
            if not re.search(rf"(?m)^\\s*{target:x}:", direct, re.I):
                errors.append(
                    f"{label}: direct disassembly produced no instruction at 0x{target:x}")
    if not emitted:
        errors.append(f"{label}: streaming disassembly found no instructions in selected IMP ranges")
        continue
    print(f"[methods] {label}: retained {emitted}/{len(ranges)} IMP ranges", flush=True)

(out / "spotify-multiplayer-method-index.txt").write_text("\n\n".join(all_indexes) + "\n", encoding="utf-8")
(out / "spotify-multiplayer-method-disassembly.txt").write_text(
    "\n\n".join(all_sections)[:12_000_000], encoding="utf-8")
if errors:
    (out / "spotify-multiplayer-methods-error.txt").write_text(
        "\n".join(errors) + "\n", encoding="utf-8")
print(f"[methods] wrote {len(all_sections)} disassembly windows", flush=True)
if not all_sections:
    raise SystemExit("No focused method disassembly windows were produced.")
