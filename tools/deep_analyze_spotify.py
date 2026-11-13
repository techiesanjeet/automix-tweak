#!/usr/bin/env python3
"""Deep, read-only symbol/string inventory for Spotify's multiplayer/mixing path."""
import pathlib, subprocess, re, sys

root = pathlib.Path.cwd()
apps = list((root / "ipa-work" / "extracted").rglob("Spotify.app"))
if not apps:
    raise SystemExit("Spotify.app not found. Run tools/analyze_ipa.py first.")
app = apps[0]
out = root / "analysis-output"
out.mkdir(exist_ok=True)

targets = [
    app / "Spotify",
    app / "Frameworks" / "SpotifyShared.framework" / "SpotifyShared",
]
needles = re.compile(
    r"mixingtransitionplayer|mixingplayingtransitioncontext|mixingplayerconstants|"
    r"mixingcoreautomix|mixingaut mix|multiplayer|playergroup|internalplayer|"
    r"audiocoordinator|audiotap|unmutedhandle|playbackrequest|transitionplayer|"
    r"fade_overlap|fade_in|fade_out|automix",
    re.I,
)
all_report = []
for binary in targets:
    if not binary.exists():
        all_report.append(f"\n## Missing: {binary}\n")
        continue
    label = str(binary.relative_to(app))
    all_report.append(f"\n## {label}\n")
    print(f"[deep] nm: {label}", flush=True)
    try:
        nm = subprocess.run(["nm", "-a", str(binary)], capture_output=True, text=True,
                            errors="replace", timeout=600)
        nm_text = nm.stdout + "\n" + nm.stderr
        (out / (binary.name + ".nm.txt")).write_text(nm_text, encoding="utf-8")
        raw_symbols = []
        for line in nm.stdout.splitlines():
            parts = line.split()
            if len(parts) >= 2 and re.fullmatch(r"[0-9a-fA-F]+", parts[0]):
                raw_symbols.append(parts[-1])
        print(f"[deep] nm complete: {len(raw_symbols)} symbol rows", flush=True)
        if raw_symbols:
            print(f"[deep] swift-demangle: {label}", flush=True)
            dem = subprocess.run(["swift-demangle"], input="\n".join(raw_symbols),
                                 capture_output=True, text=True, errors="replace", timeout=600)
            dem_lines = dem.stdout.splitlines()
            selected = [line for line in dem_lines if needles.search(line)]
            all_report.append("### Relevant demangled symbols\n" + "\n".join(selected[:12000]))
            (out / (binary.name + ".swift-demangled.txt")).write_text(dem.stdout, encoding="utf-8")
        else:
            all_report.append("No address-bearing nm symbols returned.\n")
    except subprocess.TimeoutExpired:
        all_report.append("nm timed out after 600 seconds.\n")
    except Exception as e:
        all_report.append(f"nm/demangle failed: {e}\n")

    print(f"[deep] strings: {label}", flush=True)
    try:
        st = subprocess.run(["strings", "-a", "-t", "x", str(binary)],
                            capture_output=True, text=True, errors="replace", timeout=180)
        hits = [line for line in st.stdout.splitlines() if needles.search(line)]
        all_report.append("### Relevant strings with file offsets\n" + "\n".join(hits[:12000]))
    except Exception as e:
        all_report.append(f"strings failed: {e}\n")

(out / "spotify-multiplayer-deep-scan.txt").write_text("\n".join(all_report), encoding="utf-8")
print("Wrote analysis-output/spotify-multiplayer-deep-scan.txt", flush=True)
