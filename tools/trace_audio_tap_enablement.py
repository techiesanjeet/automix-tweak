#!/usr/bin/env python3
"""Trace Objective-C selector references for the BMAudioTap enablement chain.

Objective-C IMPs are normally reached through objc_msgSend, not direct BL
branches to the IMP address. otool -tvV annotates selector-reference loads.
Static analysis only; references do not establish runtime execution.
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

SELECTORS = (
    "setShouldEnableAudioTap:",
    "shouldEnableAudioTap",
    "enableAudioTap:",
    "updateAudioTapForPlayerItem:",
    "createAudioTapWithPlayerItem:",
    "audioTapDidEmitOutput:",
    "currentPlayerItemChanged:object:",
    "itemWaitingForAudioTap",
    "audioTapFactory",
    "setAudioTap:",
    "audioTap",
)
address_re = re.compile(r"^\s*([0-9a-fA-F]{8,16})\s+(.+)$")
cmd = ["otool", "-tvV", str(binary)]
print("[audio-xrefs] streaming annotated otool disassembly", flush=True)
proc = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
                        text=True, errors="replace", bufsize=1)
before = deque(maxlen=20)
hits = []
instructions = selector_refs = 0
try:
    for raw in proc.stdout:
        line = raw.rstrip()
        m = address_re.match(line)
        if m:
            instructions += 1
        matched = [s for s in SELECTORS if s in line]
        if "Objc selector ref:" in line and matched:
            selector_refs += 1
            hits.append((matched, list(before) + [line]))
        elif matched and not m:
            # Also retain symbol/metadata lines that expose selector strings.
            hits.append((matched, list(before) + [line]))
        before.append(line)
    code = proc.wait(timeout=1200)
except Exception:
    proc.kill()
    proc.wait()
    raise

report = [
    "BMAudioTap enablement Objective-C selector-reference trace",
    "Static disassembly only; a selector reference is not proof of runtime execution.",
    f"Parsed {instructions} instruction lines; annotated selector-reference hits={selector_refs}; "
    f"all selector-string hits={len(hits)}; otool exit={code}.",
    "",
]
for i, (selectors, context) in enumerate(hits, 1):
    report.append(f"===== Selector hit {i}: {', '.join(selectors)} =====")
    report.extend(context)
    report.append("")
path = out / "spotify-audio-tap-enablement-xrefs.txt"
path.write_text("\n".join(report), encoding="utf-8")
print(f"[audio-xrefs] parsed {instructions} instructions; {selector_refs} annotated selector refs; "
      f"{len(hits)} total hits", flush=True)
if code:
    raise SystemExit(f"otool exited {code}")
