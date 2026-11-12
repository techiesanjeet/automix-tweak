#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <objc/runtime.h>

static NSString * const AMReportPathName = @"AutoMix-Spotify-Discovery-v4.txt";
static NSArray<NSString *> *AMFocusNames(void) {
 return @[@"MultiPlayer_PlayerImpl.MultiPlayerImpl",@"MultiPlayer_PlayerImpl.MultiPlayerSessionImpl",@"MultiPlayer_PlayerImpl.PlayerGroupImpl",@"MultiPlayer_PlayerImpl.InternalPlayerImpl",@"MultiPlayer_PlayerImpl.InternalPlayerFactoryImpl",@"MultiPlayer_PlayerImpl.InternalAudioCoordinator",@"MultiPlayer_PlayerImpl.SinglePlayerImpl",@"MultiPlayer_PlayerImpl.MultiPlayerAudioTap",@"MultiPlayer_PlayerImpl.AudioSessionActivationHandlerImpl",@"PlaylistMixing_TransitionPlayerImpl.MixingTransitionPlayerImpl",@"PlaylistMixing_TransitionPlayerImpl.MixingTransitionPlayerServiceImpl",@"PlaylistMixing_MixingImpl.MixingAutoMixEvaluatorImpl",@"PlaylistMixing_MixingUIImpl.MixingAutomixTransitionLoader",@"PlaylistMixing_TransitionModelKit.MixingCoreAutomixTransitionLoader",@"PlaylistMixing_TransitionModelKit.MixingTransitionParserImpl",@"NowPlaying_MixingTransitionImpl.MixingTransitionServiceImpl",@"Spotify_Automix_Proto_Overlap",@"Spotify_Automix_Proto_Preview",@"Spotify_Automix_Proto_Preset",@"Spotify_Automix_Esperanto_Proto_AutomixClient"];
}
static void AMMethods(NSMutableString *o, Class c, BOOL cls) {
 unsigned int n=0; Method *m=class_copyMethodList(cls?object_getClass(c):c,&n);
 [o appendFormat:@"  %@ methods (%u):\n",cls?@"Class":@"Instance",n];
 for(unsigned int i=0;m&&i<n&&i<100;i++) [o appendFormat:@"    %@ [types=%s]\n",NSStringFromSelector(method_getName(m[i])),method_getTypeEncoding(m[i])?: "?"];
 if(n>100)[o appendFormat:@"    ... %u omitted\n",n-100]; if(m)free(m);
}
static void AMProtocol(NSMutableString *o, Protocol *p) {
 [o appendFormat:@"  Protocol: %s\n",protocol_getName(p)?: "?"];
 BOOL reqs[]={YES,YES,NO,NO}; BOOL inst[]={YES,NO,YES,NO};
 for(int g=0;g<4;g++){unsigned int n=0;struct objc_method_description *d=protocol_copyMethodDescriptionList(p,reqs[g],inst[g],&n);
 if(n)[o appendFormat:@"    %@ (%u):\n",g==0?@"required instance":g==1?@"required class":g==2?@"optional instance":@"optional class",n];
 for(unsigned int i=0;d&&i<n&&i<60;i++)[o appendFormat:@"      %@ [types=%s]\n",NSStringFromSelector(d[i].name),d[i].types?: "?"]; if(d)free(d);}
}
static void AMDescribe(NSMutableString *o, Class c) {
 [o appendFormat:@"\n==========\nCLASS: %s\nIMAGE: %s\n",class_getName(c)?: "?",class_getImageName(c)?: "?"];
 unsigned int depth=0;
 for(Class k=c;k&&depth<8;k=class_getSuperclass(k),depth++){
  [o appendFormat:@"\n-- CLASS LEVEL %u: %s --\n",depth,class_getName(k)?: "?"];
  unsigned int n=0; Ivar *iv=class_copyIvarList(k,&n);[o appendFormat:@"Ivars (%u):\n",n];
  for(unsigned int i=0;iv&&i<n&&i<100;i++)[o appendFormat:@"  %s | %s | offset=%td\n",ivar_getName(iv[i])?: "?",ivar_getTypeEncoding(iv[i])?: "?",ivar_getOffset(iv[i])];if(iv)free(iv);
  objc_property_t *pr=class_copyPropertyList(k,&n);[o appendFormat:@"Properties (%u):\n",n];
  for(unsigned int i=0;pr&&i<n&&i<100;i++)[o appendFormat:@"  %s | %s\n",property_getName(pr[i])?: "?",property_getAttributes(pr[i])?: "?"];if(pr)free(pr);
  Protocol *__unsafe_unretained *ps=class_copyProtocolList(k,&n);[o appendFormat:@"Protocols (%u):\n",n];
  for(unsigned int i=0;ps&&i<n&&i<50;i++)AMProtocol(o,ps[i]);if(ps)free(ps);
  AMMethods(o,k,NO);AMMethods(o,k,YES);
 }
}
static NSString *AMBuildReport(void) {
 NSMutableString *o=[NSMutableString string];[o appendString:@"AUTOMIX TARGETED DISCOVERY V4\n"];
 [o appendFormat:@"Bundle: %@\nVersion: %@ (%@)\nDate: %@\n",NSBundle.mainBundle.bundleIdentifier?: @"?",NSBundle.mainBundle.infoDictionary[@"CFBundleShortVersionString"]?: @"?",NSBundle.mainBundle.infoDictionary[@"CFBundleVersion"]?: @"?",[NSDate date]];
 [o appendString:@"READ-ONLY RUNTIME METADATA. Does not invoke Spotify methods, instantiate Spotify objects, read audio buffers, decode media, or inspect track contents.\n"];
 int total=objc_getClassList(NULL,0);Class *all=total>0?calloc((size_t)total,sizeof(Class)):NULL;int actual=all?objc_getClassList(all,total):0;
 NSMutableDictionary *map=[NSMutableDictionary dictionary];for(int i=0;i<actual;i++){const char*n=class_getName(all[i]);if(n)map[[NSString stringWithUTF8String:n]]=[NSValue valueWithPointer:(__bridge const void*)all[i]];}
 [o appendFormat:@"Runtime classes scanned: %d\nFocus targets: %lu\n",actual,(unsigned long)AMFocusNames().count];
 NSMutableArray *missing=[NSMutableArray array];for(NSString *name in AMFocusNames()){NSValue*v=map[name];if(!v){[missing addObject:name];continue;}AMDescribe(o,(__bridge Class)v.pointerValue);if(o.length>180000){[o appendString:@"\nREPORT SIZE LIMIT REACHED.\n"];break;}}
 [o appendString:@"\n-- TARGETS NOT FOUND --\n"];for(NSString*n in missing)[o appendFormat:@"%@\n",n];free(all);return o;
}
static NSString *AMPath(void){NSString*d=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES).firstObject;return[d stringByAppendingPathComponent:AMReportPathName];}
@interface AMV4Controller:NSObject
@property(nonatomic,strong)UIButton*button;
+ (instancetype)shared;-(void)install;
@end
@implementation AMV4Controller
+ (instancetype)shared{static AMV4Controller*x;static dispatch_once_t once;dispatch_once(&once,^{x=[AMV4Controller new];});return x;}
-(UIWindow*)window{for(UIScene*s in UIApplication.sharedApplication.connectedScenes){if(s.activationState!=UISceneActivationStateForegroundActive||![s isKindOfClass:UIWindowScene.class])continue;for(UIWindow*w in((UIWindowScene*)s).windows)if(w.isKeyWindow)return w;}return UIApplication.sharedApplication.windows.firstObject;}
-(void)install{if(self.button)return;UIWindow*w=[self window];if(!w){dispatch_after(dispatch_time(DISPATCH_TIME_NOW,2*NSEC_PER_SEC),dispatch_get_main_queue(),^{[self install];});return;}self.button=[UIButton buttonWithType:UIButtonTypeSystem];self.button.frame=CGRectMake(MAX(8,w.bounds.size.width-132),242,124,38);self.button.backgroundColor=[UIColor colorWithRed:.15 green:.82 blue:.62 alpha:.97];[self.button setTitle:@"AUTOMIX SCAN V4" forState:UIControlStateNormal];[self.button setTitleColor:UIColor.blackColor forState:UIControlStateNormal];self.button.titleLabel.font=[UIFont boldSystemFontOfSize:10];self.button.layer.cornerRadius=9;[self.button addTarget:self action:@selector(scan) forControlEvents:UIControlEventTouchUpInside];[w addSubview:self.button];}
-(void)scan{self.button.enabled=NO;[self.button setTitle:@"SCANNING..." forState:UIControlStateNormal];dispatch_async(dispatch_get_global_queue(QOS_CLASS_UTILITY,0),^{NSString*r=AMBuildReport();NSError*e=nil;BOOL ok=[r writeToFile:AMPath() atomically:YES encoding:NSUTF8StringEncoding error:&e];NSLog(@"[AutoMixDiscoveryV4] saved=%d chars=%lu error=%@",ok,(unsigned long)r.length,e);dispatch_async(dispatch_get_main_queue(),^{self.button.enabled=YES;[self.button setTitle:@"AUTOMIX SCAN V4" forState:UIControlStateNormal];if(!ok)return;UIActivityViewController*a=[[UIActivityViewController alloc]initWithActivityItems:@[[NSURL fileURLWithPath:AMPath()]] applicationActivities:nil];UIViewController*p=[self window].rootViewController;while(p.presentedViewController)p=p.presentedViewController;if(a.popoverPresentationController){a.popoverPresentationController.sourceView=self.button;a.popoverPresentationController.sourceRect=self.button.bounds;}if(p)[p presentViewController:a animated:YES completion:nil];});});}
@end
__attribute__((constructor))static void AMV4Init(void){dispatch_after(dispatch_time(DISPATCH_TIME_NOW,15*NSEC_PER_SEC),dispatch_get_main_queue(),^{[[AMV4Controller shared]install];});}
