#!/usr/bin/env python3
"""Find static call sites for the BMAudioTap enablement chain.

Streams one complete disassembly and retains only relevant call-site context.
Static analysis only; it does not establish runtime execution.
"""
import pathlib
import re
import subprocess
from collections import deque

ROOT = pathlib.Path.cwd()
apps = list((ROOT / "ipa-work" / "extracted").rglob("Spotify.app"))
if not apps:
    raise SystemExit("Spotify.app not found; run tools/analyze_ipa.py first.")
binary = apps[0] / "Spotify"
out = ROOT / "analysis-output"
out.mkdir(exist_ok=True)

NEEDLES = (
    "setShouldEnableAudioTap",
    "shouldEnableAudioTap",
    "enableAudioTap:",
    "updateAudioTapForPlayerItem:",
    "createAudioTapWithPlayerItem:",
    "audioTapDidEmitOutput:",
)
DIRECT_TARGETS = {
    0x106d66ea4: "BMPlayerSource.setShouldEnableAudioTap:",
    0x100368c30: "BMPlayerSource.shouldEnableAudioTap",
    0x103535c00: "BMPlayerSource.enableAudioTap:",
    0x103ad2c64: "BMPlayerSource.updateAudioTapForPlayerItem:",
    0x101022b04: "BMBetamaxPlayerImpl.enableAudioTap:",
    0x107208d90: "BMAudioTapFactory.createAudioTapWithPlayerItem:",
    0x106d7af4c: "MultiPlayerAudioTap.audioTapDidEmitOutput:",
}
address_re = re.compile(r"^\s*((?:0x)?[0-9a-fA-F]{8,16}):")
target_re = re.compile(r"\\bbl\\s+(?:0x)?([0-9a-fA-F]{8,16})")

cmd = ["xcrun", "llvm-objdump", "--macho", "--disassemble", str(binary)]
print("[audio-xrefs] streaming full Spotify disassembly", flush=True)
proc = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
                        text=True, errors="replace", bufsize=1)
before = deque(maxlen=24)
hits = []
current = []
current_hit = False
instructions = 0
try:
    for raw in proc.stdout:
        line = raw.rstrip()
        if address_re.match(line):
            instructions += 1
        target = target_re.search(line)
        direct = int(target.group(1), 16) if target else None
        matched_names = [n for n in NEEDLES if n in line]
        matched_direct = DIRECT_TARGETS.get(direct) if direct is not None else None
        if matched_names or matched_direct:
            context = list(before)
            context.append(line)
            hits.append((matched_names, matched_direct, context))
            current = []
            current_hit = True
        elif current_hit:
            current.append(line)
            if len(current) >= 24:
                hits[-1][2].extend(current)
                current = []
                current_hit = False
        before.append(line)
    if current_hit and current:
        hits[-1][2].extend(current)
    code = proc.wait(timeout=600)
except Exception:
    proc.kill()
    proc.wait()
    raise

report = [
    "BMAudioTap enablement static call-site trace",
    "Static disassembly only; a call site does not prove runtime execution.",
    f"Parsed {instructions} instruction lines; objdump exit={code}.",
    "",
]
for i, (names, direct, context) in enumerate(hits, 1):
    label = ", ".join(names) if names else direct
    report.append(f"===== Hit {i}: {label} =====")
    report.extend(context)
    report.append("")
path = out / "spotify-audio-tap-enablement-xrefs.txt"
path.write_text("\n".join(report), encoding="utf-8")
print(f"[audio-xrefs] wrote {len(hits)} hits to {path}", flush=True)
if code:
    raise SystemExit(f"llvm-objdump exited {code}")
if not hits:
    raise SystemExit("No audio-tap enablement call sites found in disassembly.")
