#!/usr/bin/env python3
"""Pack a compiled Core ML .mlmodelc directory into a deterministic dylib section."""
import pathlib
import struct
import sys

root = pathlib.Path(sys.argv[1]).resolve()
output = pathlib.Path(sys.argv[2])
if not root.is_dir():
    raise SystemExit(f"model bundle directory missing: {root}")
files = sorted(p for p in root.rglob("*") if p.is_file())
if not files:
    raise SystemExit("model bundle is empty")
with output.open("wb") as out:
    out.write(b"SMBNDL01")
    out.write(struct.pack("<I", len(files)))
    for path in files:
        rel = path.relative_to(root).as_posix().encode("utf-8")
        data = path.read_bytes()
        if len(rel) > 65535:
            raise SystemExit(f"path too long: {rel!r}")
        out.write(struct.pack("<HQ", len(rel), len(data)))
        out.write(rel)
        out.write(data)
print(f"packed {len(files)} model files ({output.stat().st_size} bytes)")
