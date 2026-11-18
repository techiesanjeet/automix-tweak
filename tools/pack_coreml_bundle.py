#!/usr/bin/env python3
"""Pack a compiled Core ML resource directory into a deterministic dylib section."""
import pathlib
import struct
import sys

root = pathlib.Path(sys.argv[1]).resolve()
output = pathlib.Path(sys.argv[2])
if not root.is_dir():
    raise SystemExit(f"model resource directory missing: {root}")
files = sorted(p for p in root.rglob("*") if p.is_file())
if not files:
    raise SystemExit("model resource directory is empty")
entries = [(p.relative_to(root).as_posix(), p.read_bytes()) for p in files]
entries.append(("Info.plist", b"""<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict>
<key>CFBundleIdentifier</key><string>com.automix.smartmix.resources</string>
<key>CFBundlePackageType</key><string>BNDL</string>
</dict></plist>
"""))
entries.sort(key=lambda item: item[0])
with output.open("wb") as out:
    out.write(b"SMBNDL01")
    out.write(struct.pack("<I", len(entries)))
    for name, data in entries:
        rel = name.encode("utf-8")
        if len(rel) > 65535:
            raise SystemExit(f"path too long: {name!r}")
        out.write(struct.pack("<HQ", len(rel), len(data)))
        out.write(rel)
        out.write(data)
print(f"packed {len(entries)} model bundle files ({output.stat().st_size} bytes)")
