#!/usr/bin/env python3
"""Map unresolved audio-tap gates through Mach-O ObjC stubs to selector names."""
import pathlib, re, subprocess
ROOT=pathlib.Path.cwd()
apps=list((ROOT/"ipa-work"/"extracted").rglob("Spotify.app"))
if not apps: raise SystemExit("Spotify.app not found; run tools/analyze_ipa.py first.")
binary=apps[0]/"Spotify"
out=ROOT/"analysis-output"; out.mkdir(exist_ok=True)
targets=[(0x109bad7c0,"updateAudioTapForPlayerItem gate 1"),(0x109bb0f88,"updateAudioTapForPlayerItem gate 2")]
def run(args):
 p=subprocess.run(args,stdout=subprocess.PIPE,stderr=subprocess.STDOUT,text=True,errors="replace",timeout=600)
 if p.returncode: raise RuntimeError(f"{args[0]} exited {p.returncode}: {p.stdout[-1500:]}")
 return p.stdout
# otool prints VM addresses/sizes in hex, but file offsets/sizes as decimal.
lines=run(["otool","-l",str(binary)]).splitlines()
segments=[]; seg=None; sec=None
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
sections=[]
for sg in segments:
 for sc in sg["sections"]:
  if "addr" in sc and "size" in sc and "offset" in sc:
   sections.append((sg,sc))
def find_section(addr):
 return [(sg,sc) for sg,sc in sections if sc["addr"]<=addr<sc["addr"]+sc["size"]]
def vm_to_file(addr):
 hits=find_section(addr)
 if not hits: return None
 sg,sc=hits[0]
 return sc["offset"]+(addr-sc["addr"]),sg,sc
report=["Spotify Mach-O audio-tap gate address map",f"Binary: {binary}",f"Size: {len(data)} bytes",""]
# Full chained-fixup output is searched for selector-reference pointer slots.
fixups=run(["dyld_info","-fixup_chain_details",str(binary)])
fixup_by_offset={}
for line in fixups.splitlines():
 m=re.match(r"\\s*0x([0-9a-fA-F]+):.*?(?:target: 0x([0-9a-fA-F]+))",line)
 if m: fixup_by_offset[int(m.group(1),16)]=(int(m.group(2),16),line.strip())
for addr,label in targets:
 report += [f"===== {label}: 0x{addr:x} ====="]
 hits=find_section(addr)
 if not hits:
  report.append("No section contains this VM address."); report.append(""); continue
 sg,sc=hits[0]; off=sc["offset"]+(addr-sc["addr"])
 report.append(f"SEGMENT {sg['name']} initprot={sg.get('initprot','?')} vmaddr=0x{sg['vmaddr']:x}")
 report.append(f"SECTION {sc['name']} addr=0x{sc['addr']:x} size=0x{sc['size']:x} file_offset=0x{off:x} flags={sc.get('flags','?')}")
 chunk=data[off:off+16]
 report.append("STUB_BYTES "+chunk.hex(" "))
 if len(chunk)>=12:
  w1=int.from_bytes(chunk[0:4],"little"); w2=int.from_bytes(chunk[4:8],"little"); w3=int.from_bytes(chunk[8:12],"little")
  # Decode ADRP Xn, LDR Xn,[Xn,#imm], B imm26 sequence.
  immlo=(w1>>29)&3; immhi=(w1>>5)&0x7ffff; imm=(immhi<<2)|immlo
  if imm&(1<<20): imm-=1<<21
  page=(addr&~0xfff)+(imm<<12)
  ldr_off=((w2>>10)&0xfff)*8
  selref=page+ldr_off
  bimm=w3&0x3ffffff
  if bimm&(1<<25): bimm-=1<<26
  branch=addr+8+(bimm<<2)
  report.append(f"DECODE adrp=0x{page:x}; ldr_offset=0x{ldr_off:x}; selector_ref=0x{selref:x}; branch_target=0x{branch:x}")
  sel=vm_to_file(selref)
  if sel:
   sel_off,sel_seg,sel_sec=sel
   raw=data[sel_off:sel_off+8]
   report.append(f"SELREF_SLOT segment={sel_seg['name']} section={sel_sec['name']} file_offset=0x{sel_off:x} raw={raw.hex(' ')}")
   fx=fixup_by_offset.get(sel_off)
   if fx:
    target,desc=fx
    # chained fixup target is image-base-relative for this Mach-O.
    target_vm=0x100000000+target
    report.append(f"SELREF_FIXUP {desc}; resolved_vm=0x{target_vm:x}")
    target_map=vm_to_file(target_vm)
    if target_map:
     target_off,tseg,tsec=target_map
     tail=data[target_off:target_off+160].split(b"\\0",1)[0]
     report.append(f"SELECTOR_CSTRING segment={tseg['name']} section={tsec['name']} file_offset=0x{target_off:x}: {tail.decode('utf-8','replace')}")
   else:
    report.append("No chained-fixup record matched selector-reference file offset.")
  else: report.append("Selector-reference address did not map to a file-backed section.")
 report.append("")
report += ["===== Relevant Mach-O section inventory ====="]
for sg,sc in sections:
 if sc["name"] in ("__objc_stubs","__objc_selrefs","__objc_methname"):
  report.append(f"{sg['name']},{sc['name']},vm=0x{sc['addr']:x},size=0x{sc['size']:x},file=0x{sc['offset']:x},flags={sc.get('flags','?')}")
report += ["===== otool -Iv indirect symbols (first 4000 chars) =====",run(["otool","-Iv",str(binary)])[:4000]]
p=out/"spotify-audio-tap-gate-address-map.txt"; p.write_text("\\n".join(report)+"\\n",encoding="utf-8")
print(f"[gate-map] wrote {p} ({p.stat().st_size} bytes)")
