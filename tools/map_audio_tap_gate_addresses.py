#!/usr/bin/env python3
"""Resolve audio-tap Objective-C stub selector references to selector strings."""
import pathlib, subprocess
ROOT=pathlib.Path.cwd()
apps=list((ROOT/"ipa-work"/"extracted").rglob("Spotify.app"))
if not apps: raise SystemExit("Spotify.app not found; run tools/analyze_ipa.py first.")
binary=apps[0]/"Spotify"; out=ROOT/"analysis-output"; out.mkdir(exist_ok=True)
targets=[(0x109bad7c0,"updateAudioTapForPlayerItem gate 1"),(0x109bb0f88,"updateAudioTapForPlayerItem gate 2")]
def run(args):
 p=subprocess.run(args,stdout=subprocess.PIPE,stderr=subprocess.STDOUT,text=True,errors="replace",timeout=600)
 if p.returncode: raise RuntimeError(f"{args[0]} exited {p.returncode}: {p.stdout[-1500:]}")
 return p.stdout
lines=run(["otool","-l",str(binary)]).splitlines(); segments=[]; seg=None; sec=None
for line in lines:
 s=line.strip()
 if s=="cmd LC_SEGMENT_64": seg={"sections":[]}; segments.append(seg); sec=None
 elif seg is not None and s.startswith("segname "): seg["name"]=s.split(None,1)[1]
 elif seg is not None and s.startswith(("vmaddr ","vmsize ")):
  k,v=s.split()[:2]; seg[k]=int(v,16)
 elif seg is not None and s.startswith(("fileoff ","filesize ")):
  k,v=s.split()[:2]; seg[k]=int(v,10)
 elif seg is not None and s.startswith("initprot "): seg["initprot"]=s.split(None,1)[1]
 elif seg is not None and s.startswith("sectname "): sec={"name":s.split(None,1)[1]}; seg["sections"].append(sec)
 elif sec is not None and s.startswith(("addr ","size ")):
  k,v=s.split()[:2]; sec[k]=int(v,16)
 elif sec is not None and s.startswith("offset "): sec["offset"]=int(s.split()[1],10)
 elif sec is not None and s.startswith("flags "): sec["flags"]=s.split(None,1)[1]
 elif s.startswith("cmd ") and s!="cmd LC_SEGMENT_64": seg=None; sec=None
data=binary.read_bytes()
def locate(vm):
 for sg in segments:
  for sc in sg["sections"]:
   if all(k in sc for k in ("addr","size","offset")) and sc["addr"]<=vm<sc["addr"]+sc["size"]:
    return sc["offset"]+(vm-sc["addr"]),sg,sc
 return None
def locate_file_offset(file_offset):
 for sg in segments:
  for sc in sg["sections"]:
   if all(k in sc for k in ("addr","size","offset")) and sc["offset"]<=file_offset<sc["offset"]+sc["size"]:
    return file_offset,sg,sc
 return None
report=["Spotify Mach-O audio-tap gate selector resolution",f"Binary: {binary}",f"Size: {len(data)} bytes",""]
for address,label in targets:
 report += [f"===== {label}: 0x{address:x} ====="]
 hit=locate(address)
 if not hit: report.append("Stub address not mapped to a section."); report.append(""); continue
 off,sg,sc=hit
 report.append(f"STUB {sg['name']},{sc['name']} initprot={sg.get('initprot','?')} file=0x{off:x}")
 b=data[off:off+12]
 if len(b)<12: report.append("Stub truncated."); report.append(""); continue
 w1=int.from_bytes(b[:4],"little"); w2=int.from_bytes(b[4:8],"little"); w3=int.from_bytes(b[8:12],"little")
 imm=((w1>>5)&0x7ffff)<<2 | ((w1>>29)&3)
 if imm&(1<<20): imm-=1<<21
 page=(address&~0xfff)+(imm<<12)
 ldr_offset=((w2>>10)&0xfff)*8
 selref=page+ldr_offset
 bimm=w3&0x3ffffff
 if bimm&(1<<25): bimm-=1<<26
 branch=address+8+(bimm<<2)
 report.append(f"ADRP_PAGE=0x{page:x} LDR_OFFSET=0x{ldr_offset:x} SELREF=0x{selref:x} BRANCH=0x{branch:x}")
 ref=locate(selref)
 if not ref: report.append("Selector-reference slot not file-backed."); report.append(""); continue
 ref_off,rsg,rsc=ref
 raw=data[ref_off:ref_off+8]
 ptr=int.from_bytes(raw,"little")
 report.append(f"SELREF {rsg['name']},{rsc['name']} file=0x{ref_off:x} raw={raw.hex(' ')} pointer=0x{ptr:x}")
 # Chained-fixup selector pointers encode the target file offset in low 32 bits.
 candidates=[("vm",ptr),("top-byte-stripped-vm",ptr&0x00ffffffffffffff),
             ("chained-fixup-file-offset",ptr&0xffffffff)]
 found=False
 for kind,candidate in candidates:
  target=locate(candidate) if kind!="chained-fixup-file-offset" else locate_file_offset(candidate)
  if not target: continue
  toff,tsg,tsc=target
  if tsc["name"]!="__objc_methname": continue
  end_string=data.find(b"\\0",toff,min(toff+512,len(data)))
  if end_string<0: end_string=min(toff+512,len(data))
  value=data[toff:end_string].decode("utf-8","replace")
  vm=tsc["addr"]+(toff-tsc["offset"])
  report.append(f"SELECTOR_STRING encoding={kind} {tsg['name']},{tsc['name']} vm=0x{vm:x} file=0x{toff:x}: {value}")
  found=True; break
 if not found: report.append("Pointer did not resolve into __objc_methname by VM or chained-fixup file offset.")
 report.append("")
report.append("===== Objective-C stub section inventory =====")
for sg in segments:
 for sc in sg["sections"]:
  if sc.get("name") in ("__objc_stubs","__objc_selrefs","__objc_methname"):
   report.append(f"{sg['name']},{sc['name']},vm=0x{sc.get('addr',0):x},size=0x{sc.get('size',0):x},file=0x{sc.get('offset',0):x}")
p=out/"spotify-audio-tap-gate-address-map.txt"
p.write_text("\n".join(report)+"\n",encoding="utf-8")
print(f"[gate-map] wrote {p} ({p.stat().st_size} bytes)")
