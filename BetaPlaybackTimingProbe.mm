#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <dispatch/dispatch.h>
#include <atomic>
#include <chrono>
#include <mutex>
#include <string>
#include <vector>

namespace {
struct AMHook { Class owner; SEL selector; IMP original; std::string category; };
static std::mutex gMutex;
static std::vector<AMHook> gHooks;
static NSMutableArray<NSString *> *gEvents;
static NSMutableArray<NSString *> *gCandidates;
static std::atomic<bool> gStarted{false};
static std::atomic<unsigned> gPasses{0};
static const auto gEpoch=std::chrono::steady_clock::now();

static NSString *AMElapsed(void) {
 double t=std::chrono::duration<double>(std::chrono::steady_clock::now()-gEpoch).count();
 return [NSString stringWithFormat:@"+%.3fs",t];
}
static NSString *AMDescribe(id o) {
 if(!o || o==NSNull.null) return @"nil";
 if([o isKindOfClass:NSURL.class]) {
  NSURL *u=o; return [NSString stringWithFormat:@"NSURL(scheme=%@ host=%@ ext=%@)",u.scheme?:@"",u.host?:@"",u.pathExtension?:@""];
 }
 if([o isKindOfClass:NSString.class]) {
  NSString *s=o; NSURL *u=[NSURL URLWithString:s];
  if(u.scheme.length && u.host.length) return [NSString stringWithFormat:@"URL-string(scheme=%@ host=%@ ext=%@)",u.scheme,u.host,u.pathExtension?:@""];
  return [NSString stringWithFormat:@"NSString(len=%lu)",(unsigned long)s.length];
 }
 return NSStringFromClass([o class])?:@"object";
}
static IMP AMOriginal(id self,SEL cmd) {
 Class c=object_getClass(self); std::lock_guard<std::mutex> lock(gMutex);
 while(c) { for(const auto &h:gHooks) if(h.owner==c && h.selector==cmd) return h.original; c=class_getSuperclass(c); }
 return nullptr;
}
static void AMLog(NSString *phase,id self,SEL cmd,NSArray *args,id result) {
 NSString *cls=NSStringFromClass([self class])?:@"?";
 NSMutableString *s=[NSMutableString stringWithFormat:@"%@ %@ [%@ %@]",AMElapsed(),phase,cls,NSStringFromSelector(cmd)];
 if(args.count) { [s appendString:@" args=("]; for(NSUInteger i=0;i<args.count;i++){if(i)[s appendString:@","];[s appendString:AMDescribe(args[i])];}[s appendString:@")"]; }
 if(result) [s appendFormat:@" result=%@",AMDescribe(result)];
 @synchronized(gEvents){[gEvents addObject:s];if(gEvents.count>500)[gEvents removeObjectAtIndex:0];}
}
static NSArray *AMArgs0(void){return @[];}
static NSArray *AMArgs1(id a){return @[a?:NSNull.null];}
static NSArray *AMArgs2(id a,id b){return @[a?:NSNull.null,b?:NSNull.null];}
static NSArray *AMArgs5(id a,id b,id c,id d,id e){return @[a?:NSNull.null,b?:NSNull.null,c?:NSNull.null,d?:NSNull.null,e?:NSNull.null];}
static NSArray *AMArgs6(id a,id b,id c,id d,id e,id f){return @[a?:NSNull.null,b?:NSNull.null,c?:NSNull.null,d?:NSNull.null,e?:NSNull.null,f?:NSNull.null];}

#define AM_OBJ(N, DECL, CALL, ARR) \
static id AMObj##N(id self,SEL cmd DECL){AMLog(@"ENTER",self,cmd,ARR,nil);IMP p=AMOriginal(self,cmd);id r=p?reinterpret_cast<id(*)(id,SEL CALL)>(p)(self,cmd CALL):nil;AMLog(@"RETURN",self,cmd,@[],r);return r;}
#define AM_VOID(N, DECL, CALL, ARR) \
static void AMVoid##N(id self,SEL cmd DECL){AMLog(@"ENTER",self,cmd,ARR,nil);IMP p=AMOriginal(self,cmd);if(p)reinterpret_cast<void(*)(id,SEL CALL)>(p)(self,cmd CALL);AMLog(@"RETURN",self,cmd,@[],nil);}
AM_OBJ(0,, ,AMArgs0())
AM_VOID(0,, ,AMArgs0())
AM_OBJ(1,id a,,AMArgs1(a))
AM_VOID(1,id a,,AMArgs1(a))
AM_OBJ(2,id a,id b,id a,id b,AMArgs2(a,b))
AM_VOID(2,id a,id b,id a,id b,AMArgs2(a,b))
AM_OBJ(5,id a,id b,id c,id d,id e,id a,id b,id c,id d,id e,AMArgs5(a,b,c,d,e))
AM_VOID(5,id a,id b,id c,id d,id e,id a,id b,id c,id d,id e,AMArgs5(a,b,c,d,e))
AM_OBJ(6,id a,id b,id c,id d,id e,id f,id a,id b,id c,id d,id e,id f,AMArgs6(a,b,c,d,e,f))
AM_VOID(6,id a,id b,id c,id d,id e,id f,id a,id b,id c,id d,id e,id f,AMArgs6(a,b,c,d,e,f))

static NSString *AMCategory(NSString *sel,NSString *cls) {
 NSString *s=sel.lowercaseString,*c=cls.lowercaseString;
 if([s containsString:@"responsefromsptmedia"] && [s containsString:@"downloadurl"]) return @"DOWNLOAD_URL_RESULT";
 if([s containsString:@"getmediamanifest"] || ([c containsString:@"manifest"] && [s containsString:@"fetch"])) return @"MANIFEST_REQUEST";
 if([s containsString:@"downloadurl"]) return @"DOWNLOAD_URL";
 if([s containsString:@"providenexttracks"] || [s containsString:@"upnext"] || [s containsString:@"nexttrack"]) return @"QUEUE_NEXT";
 if([s containsString:@"createplayer"] || [s containsString:@"acquire"] || [s containsString:@"reserve"] || [s containsString:@"checkout"]) return @"PLAYER_CREATE";
 if([s containsString:@"prepare"] || [s containsString:@"updateaudiotap"]) return @"PLAYER_PREPARE";
 if([s containsString:@"didstartplayback"] || [s containsString:@"playbackstarted"] || [s containsString:@"onstartplayback"] || [s isEqualToString:@"startplayback"]) return @"TRACK_START";
 if([s containsString:@"didfinishplayback"] || [s containsString:@"playbackended"] || [s containsString:@"trackended"] || [s containsString:@"playbackfinished"]) return @"TRACK_END";
 return nil;
}
static bool AMRelevantClass(NSString *n) {
 NSString *s=n.lowercaseString;
 NSArray *terms=@[@"internalplayerimpl",@"genericplayerpool",@"manifestfetcher",@"manifest",@"upnext",@"queue",@"playerfactory",@"multiplayer",@"contextplayer",@"singleplayer",@"playerpool"];
 for(NSString *t in terms) if([s containsString:t]) return true;
 return false;
}
static char AMType(const char *t) {
 if(!t)return 0; while(*t && strchr("rnNoORV",*t))t++; return *t;
}
static IMP AMWrapper(unsigned n,bool objectReturn) {
 if(objectReturn) {switch(n){case 0:return (IMP)AMObj0;case 1:return (IMP)AMObj1;case 2:return (IMP)AMObj2;case 5:return (IMP)AMObj5;case 6:return (IMP)AMObj6;}}
 else {switch(n){case 0:return (IMP)AMVoid0;case 1:return (IMP)AMVoid1;case 2:return (IMP)AMVoid2;case 5:return (IMP)AMVoid5;case 6:return (IMP)AMVoid6;}}
 return nullptr;
}
static void AMInspectMethod(Class owner,Method m,NSString *className) {
 SEL sel=method_getName(m); NSString *sn=NSStringFromSelector(sel); NSString *cat=AMCategory(sn,className); if(!cat)return;
 const char *enc=method_getTypeEncoding(m); unsigned argc=method_getNumberOfArguments(m);
 char ret=AMType(enc); bool safe=(ret=='@'||ret=='v') && argc>=2 && argc<=8;
 for(unsigned i=2;safe && i<argc;i++){char *t=method_copyArgumentType(m,i);safe=(AMType(t)=='@');free(t);}
 unsigned n=argc>=2?argc-2:99; IMP wrapper=safe?AMWrapper(n,ret=='@'):nullptr;
 NSString *candidate=[NSString stringWithFormat:@"%@ %@ %@ args=%u return=%c encoding=%s %@",className,sn,cat,n,ret,enc?:"?",wrapper?@"HOOKABLE":@"DISCOVERED_ONLY"];
 @synchronized(gCandidates){if(![gCandidates containsObject:candidate] && gCandidates.count<250)[gCandidates addObject:candidate];}
 if(!wrapper)return;
 {
  std::lock_guard<std::mutex> lock(gMutex);
  for(const auto &h:gHooks) if(h.owner==owner && h.selector==sel)return;
  IMP original=method_getImplementation(m);
  gHooks.push_back({owner,sel,original,cat.UTF8String?:""});
 }
 IMP prior=method_setImplementation(m,wrapper);
 if(prior) {std::lock_guard<std::mutex> lock(gMutex);for(auto &h:gHooks)if(h.owner==owner&&h.selector==sel){h.original=prior;break;}}
}
static void AMInstallPass(void) {
 int total=objc_getClassList(nullptr,0); if(total<=0)return;
 Class *list=(Class *)calloc((size_t)total,sizeof(Class)); if(!list)return;
 int count=objc_getClassList(list,total);
 for(int i=0;i<count;i++) {
  Class c=list[i]; if(!c)continue; NSString *name=NSStringFromClass(c)?:@"";
  if(!AMRelevantClass(name))continue;
  unsigned n=0; Method *methods=class_copyMethodList(c,&n);
  for(unsigned j=0;j<n;j++)AMInspectMethod(c,methods[j],name);
  free(methods);
  Class meta=object_getClass(c); methods=class_copyMethodList(meta,&n);
  for(unsigned j=0;j<n;j++)AMInspectMethod(meta,methods[j],[name stringByAppendingString:@"(class)"]);
  free(methods);
 }
 free(list);
}
static void AMSchedulePass(void) {
 unsigned pass=gPasses.fetch_add(1)+1; AMInstallPass();
 if(pass<45) dispatch_after(dispatch_time(DISPATCH_TIME_NOW,2*NSEC_PER_SEC),dispatch_get_global_queue(QOS_CLASS_UTILITY,0),^{AMSchedulePass();});
}
} // namespace

extern "C" void AMBetaPlaybackTimingProbeInstall(void) {
 bool expected=false; if(!gStarted.compare_exchange_strong(expected,true))return;
 gEvents=[NSMutableArray array];gCandidates=[NSMutableArray array];
 dispatch_async(dispatch_get_global_queue(QOS_CLASS_UTILITY,0),^{AMSchedulePass();});
}
extern "C" NSString *AMBetaPlaybackTimingProbeReport(void) {
 NSMutableString *r=[NSMutableString stringWithFormat:@"BETA PLAYBACK TIMING TRACE\nInstall passes: %u\nInstalled hooks: %lu\n",
  gPasses.load(),(unsigned long)gHooks.size()];
 [r appendString:@"\nDISCOVERED METHODS (HOOKABLE means an ABI-checked wrapper was installed; DISCOVERED_ONLY was not modified):\n"];
 @synchronized(gCandidates){for(NSString *s in gCandidates)[r appendFormat:@"%@\n",s];}
 [r appendString:@"\nTIMELINE (monotonic offsets from probe start; URL query strings are never recorded):\n"];
 @synchronized(gEvents){for(NSString *s in gEvents)[r appendFormat:@"%@\n",s];}
 [r appendString:@"\nNo playback commands, queue mutations, network requests, or audio-buffer reads are performed by this probe.\n"];
 return r;
}
