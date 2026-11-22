#!/usr/bin/env python3
"""Find direct and indirect references around the BMAudioTap enablement chain.

Streams one complete disassembly and retains relevant references plus diagnostics.
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
branch_re = re.compile(r"\bbl\s+(?:0x)?([0-9a-fA-F]{8,16})")
blr_re = re.compile(r"\bblr\s+([wx]\d+)")
hex_re = re.compile(r"0x([0-9a-fA-F]{8,16})")

cmd = ["xcrun", "llvm-objdump", "--macho", "--disassemble", str(binary)]
print("[audio-xrefs] streaming full Spotify disassembly", flush=True)
proc = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
                        text=True, errors="replace", bufsize=1)
before = deque(maxlen=16)
hits = []
instructions = branches = indirect_branches = direct_matches = address_refs = name_matches = 0
branch_samples = []
try:
    for raw in proc.stdout:
        line = raw.rstrip()
        if address_re.match(line):
            instructions += 1
        branch = branch_re.search(line)
        indirect = blr_re.search(line)
        if branch:
            branches += 1
            if len(branch_samples) < 30:
                branch_samples.append(line)
        if indirect:
            indirect_branches += 1

        referenced = []
        for value in hex_re.findall(line):
            label = DIRECT_TARGETS.get(int(value, 16))
            if label and label not in referenced:
                referenced.append(label)
        matched_names = [n for n in NEEDLES if n in line]
        direct = DIRECT_TARGETS.get(int(branch.group(1), 16)) if branch else None

        if direct:
            direct_matches += 1
        if referenced:
            address_refs += len(referenced)
        if matched_names:
            name_matches += len(matched_names)

        labels = []
        labels.extend(matched_names)
        if direct:
            labels.append("direct-call-target: " + direct)
        labels.extend("address-reference: " + x for x in referenced if x != direct)
        if labels:
            context = list(before)
            context.append(line)
            hits.append((labels, context))
        before.append(line)
    code = proc.wait(timeout=600)
except Exception:
    proc.kill()
    proc.wait()
    raise

report = [
    "BMAudioTap enablement static reference trace",
    "Static disassembly only; a reference does not prove runtime execution.",
    f"Parsed {instructions} instruction lines; direct BL={branches}; indirect BLR={indirect_branches};",
    f"known direct-target matches={direct_matches}; known-address references={address_refs}; method-name matches={name_matches}; objdump exit={code}.",
    "",
    "===== Sample direct branch instructions (first 30) =====",
    *branch_samples,
    "",
]
for i, (labels, context) in enumerate(hits, 1):
    report.append(f"===== Reference {i}: {', '.join(labels)} =====")
    report.extend(context)
    report.append("")
path = out / "spotify-audio-tap-enablement-xrefs.txt"
path.write_text("\n".join(report), encoding="utf-8")
print(f"[audio-xrefs] parsed {instructions} instructions, {branches} BL, {indirect_branches} BLR, "
      f"{direct_matches} known direct targets, {address_refs} address refs, {name_matches} name matches; "
      f"wrote {len(hits)} references", flush=True)
if code:
    raise SystemExit(f"llvm-objdump exited {code}")
