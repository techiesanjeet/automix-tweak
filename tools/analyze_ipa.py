#!/usr/bin/env python3
import os, re, html, zipfile, pathlib, subprocess, urllib.request, urllib.parse

ROOT = pathlib.Path.cwd()
OUT = ROOT / "analysis-output"
WORK = ROOT / "ipa-work"
OUT.mkdir(exist_ok=True)
WORK.mkdir(exist_ok=True)
URL = os.environ.get("IPA_URL", "").strip()
if not URL:
    raise SystemExit("IPA_URL input is empty")

def fetch(url, dest):
    req = urllib.request.Request(url, headers={"User-Agent": "Mozilla/5.0"})
    with urllib.request.urlopen(req, timeout=90) as response:
        data = response.read()
    if data[:2] == b"PK":
        dest.write_bytes(data)
        return
    page = data.decode("utf-8", "replace")
    candidates = []
    patterns = [
        r'<a[^>]+id=["\']downloadButton["\'][^>]+href=["\']([^"\']+)',
        r'<a[^>]+href=["\']([^"\']+)["\'][^>]+id=["\']downloadButton["\']',
        r'"downloadUrl"\s*:\s*"([^"]+)"',
    ]
    for pat in patterns:
        candidates += re.findall(pat, page, re.I)
    if not candidates:
        raise RuntimeError("URL returned a webpage, not an IPA, and no MediaFire download button could be extracted. Supply a direct .ipa URL.")
    direct = html.unescape(candidates[0]).replace("\\/", "/")
    if direct.startswith("//"):
        direct = "https:" + direct
    elif direct.startswith("/"):
        direct = urllib.parse.urljoin(url, direct)
    req2 = urllib.request.Request(direct, headers={"User-Agent": "Mozilla/5.0", "Referer": url})
    with urllib.request.urlopen(req2, timeout=180) as response:
        data = response.read()
    if data[:2] != b"PK":
        raise RuntimeError("Resolved download did not return a ZIP/IPA. The host may require a direct link.")
    dest.write_bytes(data)

ipa = WORK / "input.ipa"
print("Downloading IPA (URL is not printed)...", flush=True)
fetch(URL, ipa)
print("Downloaded %s bytes" % format(ipa.stat().st_size, ","), flush=True)
extract_root = WORK / "extracted"
extract_root.mkdir(exist_ok=True)
with zipfile.ZipFile(ipa) as z:
    names = z.namelist()
    print("Archive entries: %s" % len(names), flush=True)
    z.extractall(extract_root)

# Some download hosts wrap the actual IPA inside another ZIP, and some
# repackaging tools add a directory above Payload. Search recursively.
app_dirs = list(extract_root.rglob("*.app"))
if not app_dirs:
    nested_archives = list(extract_root.rglob("*.ipa")) + list(extract_root.rglob("*.zip"))
    for nested in nested_archives:
        try:
            nested_root = WORK / ("nested-" + nested.stem)
            nested_root.mkdir(exist_ok=True)
            with zipfile.ZipFile(nested) as z:
                z.extractall(nested_root)
            app_dirs.extend(nested_root.rglob("*.app"))
            if app_dirs:
                print("Found app inside nested archive: %s" % nested.name, flush=True)
                break
        except (zipfile.BadZipFile, OSError) as e:
            print("Skipping nested archive %s: %s" % (nested.name, e), flush=True)

if not app_dirs:
    sample = "\\n".join(names[:40])
    raise RuntimeError("No .app bundle found after recursive extraction. First archive entries:\\n" + sample)
app = app_dirs[0]
print("Selected app bundle: %s" % app, flush=True)

def run(args, timeout=90):
    try:
        p = subprocess.run(args, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True, errors="replace", timeout=timeout)
        return p.stdout
    except Exception as e:
        return "[command failed: %s]" % e

def is_macho(path):
    out = run(["file", "-b", str(path)], timeout=15)
    return "Mach-O" in out, out.strip()

bins = []
for p in app.rglob("*"):
    if p.is_file():
        ok, desc = is_macho(p)
        if ok:
            bins.append((p, desc))
bins.sort(key=lambda x: (0 if x[0].name == app.stem else 1, str(x[0])))

keywords = re.compile(r"automix|auto.?mix|playlist.?mix|mixing|overlap|transition|cross.?fade|crossfade|multiplayer|playerpool|player.?group|audio.?tap|unmutedhandle|playbackrequest|cue.?point|beat.?match|preview", re.I)
inventory, hits, mix_symbols, swift_symbols = [], [], [], []
report = [
    "# Taurus IPA static reverse-engineering report", "",
    "- App bundle: %s" % app.name,
    "- Mach-O images discovered: **%s**" % len(bins),
    "- IPA size: **%s bytes**" % format(ipa.stat().st_size, ","),
    "- Analysis is static; no app code was executed.", "",
    "## Important limitation",
    "This analyzes the supplied IPA binary and embedded Mach-O images. It does not recover Spotify's original source code. FairPlay-encrypted code pages, stripped symbols, compiler optimization and obfuscation can limit disassembly and naming.", ""
]
for idx, (p, desc) in enumerate(bins, 1):
    rel = str(p.relative_to(app))
    inventory.append("%s\t%s\t%s" % (idx, rel, desc))
    print("[%s/%s] %s" % (idx, len(bins), rel), flush=True)
    load = run(["otool", "-l", str(p)], timeout=60)
    crypt = "unknown"
    m = re.search(r"cryptid\s+(\d+)", load)
    if m: crypt = m.group(1)
    arch = run(["lipo", "-archs", str(p)], timeout=15).strip()
    syms = run(["nm", "-a", str(p)], timeout=90)
    strs = run(["strings", "-a", str(p)], timeout=90)
    matched = [line for line in (syms + "\n" + strs).splitlines() if keywords.search(line)]
    if matched:
        hits.append("\n===== %s =====\n" % rel + "\n".join(matched[:500]))
    for line in syms.splitlines():
        if re.search(r"automix|mixing|overlap|transition|cross.?fade|multiplayer|playerpool|player.?group|audio.?tap|playbackrequest", line, re.I):
            mix_symbols.append("%s\t%s" % (rel, line))
        if "$s" in line or "_$s" in line or "$S" in line:
            swift_symbols.append(line.split()[-1] if line.split() else line)
    if idx <= 30 or keywords.search(rel):
        report += [
            "### %s. %s" % (idx, rel),
            "- File type: %s" % desc,
            "- Architectures: %s" % (arch or "unknown"),
            "- FairPlay cryptid: %s (0 generally means not encrypted; 1 means encrypted code pages)" % crypt,
            "- Symbol table text size: %s chars" % format(len(syms), ","),
            "- String table text size: %s chars" % format(len(strs), ","),
            "- Matching symbol/string lines: %s" % len(matched), ""
        ]

unique_swift = list(dict.fromkeys(swift_symbols))
demangled = "No Swift symbols found in symbol tables.\n"
if unique_swift:
    try:
        proc = subprocess.run(["swift-demangle"], input="\n".join(unique_swift[:20000]), text=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, timeout=120)
        demangled = proc.stdout
    except Exception as e:
        demangled = "Demangling unavailable: %s\n" % e + "\n".join(unique_swift[:20000])
(OUT / "swift-symbols-demangled.txt").write_text(demangled, encoding="utf-8")
(OUT / "binary-inventory.tsv").write_text("\n".join(inventory) + "\n", encoding="utf-8")
(OUT / "keyword-hits.txt").write_text("\n".join(hits) or "No keyword hits found.\n", encoding="utf-8")
(OUT / "automix-symbols.txt").write_text("\n".join(mix_symbols) or "No matching symbols found.\n", encoding="utf-8")
report += [
    "## Analysis files",
    "- binary-inventory.tsv: all discovered Mach-O files, relative paths and file types.",
    "- keyword-hits.txt: AutoMix/player/mixing-related symbol and string hits, grouped by binary.",
    "- automix-symbols.txt: matching symbol-table entries.",
    "- swift-symbols-demangled.txt: Swift symbols found in Mach-O symbol tables, demangled where possible.", "",
    "## Interpretation guidance",
    "- cryptid 1 means encrypted code pages may prevent meaningful disassembly without a decrypted binary.",
    "- Strings and symbol names are leads, not proof that a method is called in the playback path.",
    "- Next, correlate AutoMix protobuf/model fields and transition services with the multi-player implementation, then inspect call sites and control flow in the main executable and relevant frameworks."
]
(OUT / "REPORT.md").write_text("\n".join(report), encoding="utf-8")
print("Finished: %s Mach-O images analyzed" % len(bins), flush=True)
