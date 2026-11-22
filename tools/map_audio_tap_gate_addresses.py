#!/usr/bin/env python3
"""Map unresolved audio-tap gate addresses to Mach-O segments, sections and file bytes."""
import pathlib, subprocess
ROOT=pathlib.Path.cwd()
apps=list((ROOT/"ipa-work"/"extracted").rglob("Spotify.app"))
if not apps: raise SystemExit("Spotify.app not found; run tools/analyze_ipa.py first.")
binary=apps[0]/"Spotify"
out=ROOT/"analysis-output"; out.mkdir(exist_ok=True)
targets=[(0x109bad7c0,"updateAudioTapForPlayerItem gate 1"),(0x109bb0f88,"updateAudioTapForPlayerItem gate 2")]
def run(args):
 p=subprocess.run(args,stdout=subprocess.PIPE,stderr=subprocess.STDOUT,text=True,errors="replace",timeout=300)
 if p.returncode: raise RuntimeError(f"{args[0]} exited {p.returncode}: {p.stdout[-1500:]}")
 return p.stdout
lines=run(["otool","-l",str(binary)]).splitlines()
segments=[]; seg=None; sec=None
for line in lines:
 s=line.strip()
 if s=="cmd LC_SEGMENT_64": seg={"sections":[]}; segments.append(seg); sec=None
 elif seg is not None and s.startswith("segname "): seg["name"]=s.split(None,1)[1]
 elif seg is not None and s.startswith(("vmaddr ","vmsize ","fileoff ","filesize ")):
  k,v=s.split()[:2]; seg[k]=int(v,16)
 elif seg is not None and s.startswith("initprot "): seg["initprot"]=s.split(None,1)[1]
 elif seg is not None and s.startswith("sectname "): sec={"name":s.split(None,1)[1]}; seg["sections"].append(sec)
 elif sec is not None and s.startswith(("addr ","size ","offset ","flags ")):
  k,v=s.split(None,1)
  sec[k]=int(v,16) if k in ("addr","size","offset") else v
 elif s.startswith("cmd ") and s!="cmd LC_SEGMENT_64": seg=None; sec=None
data=binary.read_bytes(); report=["Spotify Mach-O audio-tap gate address map",f"Binary: {binary}",f"Size: {len(data)} bytes",""]
for addr,label in targets:
 report += [f"===== {label}: 0x{addr:x} ====="]
 found=False
 for sg in segments:
  if "vmaddr" not in sg or not sg["vmaddr"]<=addr<sg["vmaddr"]+sg.get("vmsize",0): continue
  found=True; report.append(f"SEGMENT {sg.get('name')} vmaddr=0x{sg['vmaddr']:x} vmsize=0x{sg.get('vmsize',0):x} fileoff=0x{sg.get('fileoff',0):x} filesize=0x{sg.get('filesize',0):x} initprot={sg.get('initprot','?')}")
  matched=False
  for sc in sg["sections"]:
   if "addr" not in sc or not sc["addr"]<=addr<sc["addr"]+sc.get("size",0): continue
   matched=True; off=sc.get("offset",0)+addr-sc["addr"]
   report.append(f"SECTION {sc.get('name')} addr=0x{sc['addr']:x} size=0x{sc.get('size',0):x} offset=0x{sc.get('offset',0):x} flags={sc.get('flags','?')} file_offset=0x{off:x}")
   chunk=data[off:off+128]
   report.append("BYTES "+chunk.hex(" "))
   for i in range(0,len(chunk)-3,4): report.append(f" +0x{i:02x}: {chunk[i:i+4].hex()} LE=0x{int.from_bytes(chunk[i:i+4],'little'):08x}")
  if not matched: report.append("No section record contains address.")
  delta=addr-sg["vmaddr"]
  if delta<sg.get("filesize",0):
   off=sg["fileoff"]+delta; report.append(f"SEGMENT_FILE_BYTES offset=0x{off:x}: {data[off:off+64].hex(' ')}")
 if not found: report.append("No LC_SEGMENT_64 contains this VM address.")
 report.append("")
try: report += ["===== otool -Iv indirect symbol table =====",run(["otool","-Iv",str(binary)])[:12000]]
except Exception as e: report.append(f"otool -Iv unavailable: {e}")
try: report += ["===== dyld_info fixup chain details =====",run(["dyld_info","-fixup_chain_details",str(binary)])[:16000]]
except Exception as e: report.append(f"dyld_info fixup details unavailable: {e}")
p=out/"spotify-audio-tap-gate-address-map.txt"; p.write_text("\n".join(report)+"\n",encoding="utf-8"); print(f"[gate-map] wrote {p} ({p.stat().st_size} bytes)")
