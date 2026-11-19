#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <dispatch/dispatch.h>
#include <atomic>
#include <chrono>
#include <cstring>
#include <cstdlib>
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
 if(!o || o==NSNull.null)return @"nil";
 if([o isKindOfClass:NSURL.class]){NSURL *u=o;return [NSString stringWithFormat:@"NSURL(scheme=%@ host=%@ ext=%@)",u.scheme?:@"",u.host?:@"",u.pathExtension?:@""];}
 if([o isKindOfClass:NSString.class]){NSString *s=o;NSURL *u=[NSURL URLWithString:s];if(u.scheme.length&&u.host.length)return [NSString stringWithFormat:@"URL-string(scheme=%@ host=%@ ext=%@)",u.scheme,u.host,u.pathExtension?:@""];return [NSString stringWithFormat:@"NSString(len=%lu)",(unsigned long)s.length];}
 return NSStringFromClass([o class])?:@"object";
}
static IMP AMOriginal(id self,SEL cmd) {
 Class c=object_getClass(self);std::lock_guard<std::mutex> lock(gMutex);
 while(c){for(const auto &h:gHooks)if(h.owner==c&&h.selector==cmd)return h.original;c=class_getSuperclass(c);}return nullptr;
}
static void AMLog(NSString *phase,id self,SEL cmd,NSArray *args,id result) {
 NSString *cls=NSStringFromClass([self class])?:@"?";
 NSMutableString *s=[NSMutableString stringWithFormat:@"%@ %@ [%@ %@]",AMElapsed(),phase,cls,NSStringFromSelector(cmd)];
 if(args.count){[s appendString:@" args=("];for(NSUInteger i=0;i<args.count;i++){if(i)[s appendString:@","];[s appendString:AMDescribe(args[i])];}[s appendString:@")"];}
 if(result)[s appendFormat:@" result=%@",AMDescribe(result)];
 @synchronized(gEvents){[gEvents addObject:s];if(gEvents.count>500)[gEvents removeObjectAtIndex:0];}
}
static NSArray *A0(void){return @[];}
static NSArray *A1(id a){return @[a?:NSNull.null];}
static NSArray *A2(id a,id b){return @[a?:NSNull.null,b?:NSNull.null];}
static NSArray *A5(id a,id b,id c,id d,id e){return @[a?:NSNull.null,b?:NSNull.null,c?:NSNull.null,d?:NSNull.null,e?:NSNull.null];}
static NSArray *A6(id a,id b,id c,id d,id e,id f){return @[a?:NSNull.null,b?:NSNull.null,c?:NSNull.null,d?:NSNull.null,e?:NSNull.null,f?:NSNull.null];}

static id O0(id s,SEL c){AMLog(@"ENTER",s,c,A0(),nil);IMP p=AMOriginal(s,c);id r=p?((id(*)(id,SEL))p)(s,c):nil;AMLog(@"RETURN",s,c,A0(),r);return r;}
static void V0(id s,SEL c){AMLog(@"ENTER",s,c,A0(),nil);IMP p=AMOriginal(s,c);if(p)((void(*)(id,SEL))p)(s,c);AMLog(@"RETURN",s,c,A0(),nil);}
static id O1(id s,SEL c,id a){AMLog(@"ENTER",s,c,A1(a),nil);IMP p=AMOriginal(s,c);id r=p?((id(*)(id,SEL,id))p)(s,c,a):nil;AMLog(@"RETURN",s,c,A0(),r);return r;}
static void V1(id s,SEL c,id a){AMLog(@"ENTER",s,c,A1(a),nil);IMP p=AMOriginal(s,c);if(p)((void(*)(id,SEL,id))p)(s,c,a);AMLog(@"RETURN",s,c,A0(),nil);}
static id O2(id s,SEL c,id a,id b){AMLog(@"ENTER",s,c,A2(a,b),nil);IMP p=AMOriginal(s,c);id r=p?((id(*)(id,SEL,id,id))p)(s,c,a,b):nil;AMLog(@"RETURN",s,c,A0(),r);return r;}
static void V2(id s,SEL c,id a,id b){AMLog(@"ENTER",s,c,A2(a,b),nil);IMP p=AMOriginal(s,c);if(p)((void(*)(id,SEL,id,id))p)(s,c,a,b);AMLog(@"RETURN",s,c,A0(),nil);}
static id O5(id s,SEL c,id a,id b,id d,id e,id f){AMLog(@"ENTER",s,c,A5(a,b,d,e,f),nil);IMP p=AMOriginal(s,c);id r=p?((id(*)(id,SEL,id,id,id,id,id))p)(s,c,a,b,d,e,f):nil;AMLog(@"RETURN",s,c,A0(),r);return r;}
static void V5(id s,SEL c,id a,id b,id d,id e,id f){AMLog(@"ENTER",s,c,A5(a,b,d,e,f),nil);IMP p=AMOriginal(s,c);if(p)((void(*)(id,SEL,id,id,id,id,id))p)(s,c,a,b,d,e,f);AMLog(@"RETURN",s,c,A0(),nil);}
static id O6(id s,SEL c,id a,id b,id d,id e,id f,id g){AMLog(@"ENTER",s,c,A6(a,b,d,e,f,g),nil);IMP p=AMOriginal(s,c);id r=p?((id(*)(id,SEL,id,id,id,id,id,id))p)(s,c,a,b,d,e,f,g):nil;AMLog(@"RETURN",s,c,A0(),r);return r;}
static void V6(id s,SEL c,id a,id b,id d,id e,id f,id g){AMLog(@"ENTER",s,c,A6(a,b,d,e,f,g),nil);IMP p=AMOriginal(s,c);if(p)((void(*)(id,SEL,id,id,id,id,id,id))p)(s,c,a,b,d,e,f,g);AMLog(@"RETURN",s,c,A0(),nil);}

static bool AMLifecycleClass(NSString *name) {
 NSString *c=name.lowercaseString;
 if([c containsString:@"alert"]||[c containsString:@"notification"]||[c containsString:@"ui"])return false;
 return [c containsString:@"player"]||[c containsString:@"playback"]||[c containsString:@"session"]||
        [c containsString:@"context"]||[c containsString:@"observer"]||[c containsString:@"coordinator"];
}
static NSString *AMCategory(NSString *sel,NSString *cls) {
 NSString *s=sel.lowercaseString,*c=cls.lowercaseString;
 if([s containsString:@"responsefromsptmedia"]&&[s containsString:@"downloadurl"])return @"DOWNLOAD_URL_RESULT";
 if([s containsString:@"getmediamanifest"]||([c containsString:@"manifest"]&&[s containsString:@"fetch"]))return @"MANIFEST_REQUEST";
 if([s containsString:@"downloadurl"])return @"DOWNLOAD_URL";
 if([s isEqualToString:@"createaudiotapwithplayeritem:completion:"] ||
    ([c containsString:@"audiotapfactory"] && [s containsString:@"createaudiotap"]))return @"AUDIO_TAP_FACTORY";
 if([s isEqualToString:@"processaudiobufferlist:samplerate:"])return @"AUDIO_TAP_PROCESS_DISCOVERY";
 if([c containsString:@"multiplayerobserverbridge"] &&
    ([s containsString:@"didstartrenderingatposition"] ||
     [s containsString:@"didcreateplaybackwithattributes"] ||
     [s containsString:@"didloadmanifest"] ||
     [s containsString:@"didbecomereadyatposition"] ||
     [s containsString:@"didendplaybackwithreason"] ||
     [s containsString:@"didstartbufferingatposition"]))return @"PLAYBACK_OBSERVER_EVENT";
 if([s containsString:@"providenexttracks"]||[s containsString:@"upnext"]||[s containsString:@"nexttrack"])return @"QUEUE_NEXT";
 if([s containsString:@"createplayer"]||[s containsString:@"acquire"]||[s containsString:@"reserve"]||[s containsString:@"checkout"])return @"PLAYER_CREATE";
 if([s containsString:@"prepare"]||[s containsString:@"updateaudiotap"])return @"PLAYER_PREPARE";
 if(AMLifecycleClass(cls)&&([s containsString:@"didstartplayback"]||[s containsString:@"playbackstarted"]||
    [s containsString:@"onstartplayback"]||[s isEqualToString:@"startplayback"]))return @"TRACK_START";
 if(AMLifecycleClass(cls)&&([s containsString:@"didfinishplayback"]||[s containsString:@"playbackended"]||
    [s containsString:@"trackended"]||[s containsString:@"playbackfinished"]))return @"TRACK_END";
 return nil;
}
static bool AMRelevantClass(NSString *n) {
 NSString *s=n.lowercaseString;NSArray *terms=@[@"internalplayerimpl",@"genericplayerpool",@"manifestfetcher",@"manifest",@"upnext",@"queue",@"playerfactory",@"multiplayer",@"contextplayer",@"singleplayer",@"playerpool",@"bmaudiotapfactory",@"bmsamplebufferaudiotap"];
 for(NSString *t in terms)if([s containsString:t])return true;return false;
}
static char AMType(const char *t){if(!t)return 0;while(*t&&strchr("rnNoORV",*t))t++;return *t;}
static IMP AMWrapper(unsigned n,bool obj) {
 if(obj){switch(n){case 0:return (IMP)O0;case 1:return (IMP)O1;case 2:return (IMP)O2;case 5:return (IMP)O5;case 6:return (IMP)O6;}}
 else{switch(n){case 0:return (IMP)V0;case 1:return (IMP)V1;case 2:return (IMP)V2;case 5:return (IMP)V5;case 6:return (IMP)V6;}}
 return nullptr;
}
static void AMInspectMethod(Class owner,Method m,NSString *className) {
 SEL sel=method_getName(m);NSString *sn=NSStringFromSelector(sel);NSString *cat=AMCategory(sn,className);if(!cat)return;
 const char *enc=method_getTypeEncoding(m);unsigned argc=method_getNumberOfArguments(m);char ret=AMType(enc);
 bool safe=(ret=='@'||ret=='v')&&argc>=2&&argc<=8;
 for(unsigned i=2;safe&&i<argc;i++){char *t=method_copyArgumentType(m,i);safe=AMType(t)=='@';free(t);}
 unsigned n=argc>=2?argc-2:99;IMP wrapper=safe?AMWrapper(n,ret=='@'):nullptr;
 NSString *candidate=[NSString stringWithFormat:@"%@ %@ %@ args=%u return=%c encoding=%s %@",className,sn,cat,n,ret,enc?:"?",wrapper?@"HOOKABLE":@"DISCOVERED_ONLY"];
 @synchronized(gCandidates){if(![gCandidates containsObject:candidate]&&gCandidates.count<250)[gCandidates addObject:candidate];}
 if(!wrapper)return;
 {std::lock_guard<std::mutex> lock(gMutex);for(const auto &h:gHooks)if(h.owner==owner&&h.selector==sel)return;gHooks.push_back({owner,sel,method_getImplementation(m),cat.UTF8String?:""});}
 IMP prior=method_setImplementation(m,wrapper);
 if(prior){std::lock_guard<std::mutex> lock(gMutex);for(auto &h:gHooks)if(h.owner==owner&&h.selector==sel){h.original=prior;break;}}
}
static void AMInstallPass(void) {
 int total=objc_getClassList(nullptr,0);if(total<=0)return;Class *list=(Class *)calloc((size_t)total,sizeof(Class));if(!list)return;int count=objc_getClassList(list,total);
 for(int i=0;i<count;i++){Class c=list[i];if(!c)continue;NSString *name=NSStringFromClass(c)?:@"";if(!AMRelevantClass(name))continue;
  unsigned n=0;Method *m=class_copyMethodList(c,&n);for(unsigned j=0;j<n;j++)AMInspectMethod(c,m[j],name);free(m);
  Class meta=object_getClass(c);m=class_copyMethodList(meta,&n);for(unsigned j=0;j<n;j++)AMInspectMethod(meta,m[j],[name stringByAppendingString:@"(class)"]);free(m);
 }free(list);
}
static void AMSchedule(void){unsigned p=gPasses.fetch_add(1)+1;AMInstallPass();if(p<45)dispatch_after(dispatch_time(DISPATCH_TIME_NOW,2*NSEC_PER_SEC),dispatch_get_global_queue(QOS_CLASS_UTILITY,0),^{AMSchedule();});}
}
extern "C" void AMBetaPlaybackTimingProbeInstall(void) {
 bool expected=false;if(!gStarted.compare_exchange_strong(expected,true))return;gEvents=[NSMutableArray array];gCandidates=[NSMutableArray array];
 dispatch_async(dispatch_get_global_queue(QOS_CLASS_UTILITY,0),^{AMSchedule();});
}
extern "C" NSString *AMBetaPlaybackTimingProbeReport(void) {
 NSMutableString *r=[NSMutableString stringWithFormat:@"BETA PLAYBACK TIMING TRACE\nInstall passes: %u\nInstalled hooks: %lu\n",gPasses.load(),(unsigned long)gHooks.size()];
 [r appendString:@"\nDISCOVERED METHODS (HOOKABLE = ABI-checked wrapper installed; DISCOVERED_ONLY = not modified):\n"];
 @synchronized(gCandidates){for(NSString *s in gCandidates)[r appendFormat:@"%@\n",s];}
 [r appendString:@"\nTIMELINE (monotonic offsets; URL query strings are never recorded):\n"];
 @synchronized(gEvents){for(NSString *s in gEvents)[r appendFormat:@"%@\n",s];}
 [r appendString:@"\nThis probe does not issue playback commands, mutate the queue, request streams, or read audio buffers.\n"];
 return r;
}
