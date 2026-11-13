#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import <mach-o/dyld.h>
#import <dlfcn.h>
#import <dispatch/dispatch.h>
#import <string.h>

static NSString *V8S(const char *s) { return s ? [NSString stringWithUTF8String:s] : @""; }
static BOOL V8ContainsAny(NSString *value, NSArray<NSString *> *terms) {
    NSString *v=value.lowercaseString;
    for (NSString *term in terms) if ([v containsString:term]) return YES;
    return NO;
}
static NSArray<NSString *> *V8FocusTerms(void) {
    return @[@"automix",@"mixing",@"transitionplayer",@"transitionloader",
      @"transitionservice",@"multiplayer",@"playerpool",@"playergroup",
      @"internalplayer",@"audiocoordinator",@"audiotap",@"playbackrequest",
      @"unmutedhandle",@"mutecontroller",@"mixingevaluator",@"mixingstate"];
}
static NSArray<NSString *> *V8MethodTerms(void) {
    return @[@"play",@"pause",@"stop",@"seek",@"transition",@"mix",@"fade",
      @"volume",@"mute",@"unmute",@"audio",@"player",@"pool",@"group",
      @"activate",@"deactivate",@"prepare",@"start",@"end",@"context",
      @"subject",@"observe",@"subscribe",@"output",@"render",@"route",
      @"session",@"current",@"next",@"previous",@"track",@"state"];
}
static BOOL V8IsSpotifyImage(const char *path) {
    NSString *p=V8S(path).lowercaseString;
    return [p containsString:@"spotify.app/"] || [p containsString:@"/spotify/"];
}
static NSString *V8ImageForAddress(const void *address, NSString **offsetOut) {
    Dl_info info={0};
    if (address && dladdr(address,&info) && info.dli_fname) {
        uintptr_t base=(uintptr_t)info.dli_fbase, ptr=(uintptr_t)address;
        if (offsetOut) *offsetOut=(ptr>=base)?[NSString stringWithFormat:@"0x%llx",(unsigned long long)(ptr-base)]:@"unknown";
        return V8S(info.dli_fname);
    }
    if(offsetOut)*offsetOut=@"unknown";
    return @"(image unavailable)";
}
static void V8AppendMethodList(NSMutableString *out, Class c, BOOL classMethods, NSUInteger *total) {
    Class target=classMethods?object_getClass(c):c;
    unsigned int count=0;
    Method *methods=class_copyMethodList(target,&count);
    [out appendFormat:@"  %@ METHODS (%u)\n",classMethods?@"CLASS":@"INSTANCE",count];
    NSUInteger emitted=0;
    for(unsigned int i=0;i<count && emitted<180;i++) {
        Method m=methods[i];
        SEL sel=method_getName(m);
        NSString *name=NSStringFromSelector(sel);
        const char *types=method_getTypeEncoding(m);
        IMP imp=method_getImplementation(m);
        NSString *offset=nil;
        NSString *image=V8ImageForAddress((const void *)imp,&offset);
        [out appendFormat:@"    %@ | types=%@ | IMP=%@+%@\n",name,V8S(types),image.lastPathComponent,offset];
        emitted++; (*total)++;
    }
    if(count>emitted)[out appendFormat:@"    ... %u more methods omitted\n",count-(unsigned int)emitted];
    free(methods);
}
static void V8AppendProtocols(NSMutableString *out, Class c) {
    unsigned int count=0;
    Protocol *__unsafe_unretained *protocols=class_copyProtocolList(c,&count);
    [out appendFormat:@"  PROTOCOLS (%u)\n",count];
    for(unsigned int i=0;i<count;i++) {
        Protocol *p=protocols[i];
        [out appendFormat:@"    %@\n",V8S(protocol_getName(p))];
        for(int required=1;required>=0;required--) {
            for(int instance=1;instance>=0;instance--) {
                unsigned int n=0;
                struct objc_method_description *descs=protocol_copyMethodDescriptionList(
                    p,required?YES:NO,instance?YES:NO,&n);
                for(unsigned int j=0;j<n && j<100;j++) {
                    [out appendFormat:@"      %@ %@ %@ | %@\n",
                      required?@"required":@"optional",instance?@"instance":@"class",
                      NSStringFromSelector(descs[j].name),V8S(descs[j].types)];
                }
                free(descs);
            }
        }
    }
    free(protocols);
}
static void V8AppendClass(NSMutableString *out, Class c, NSUInteger *methodTotal) {
    NSString *name=V8S(class_getName(c));
    Class sup=class_getSuperclass(c);
    [out appendFormat:@"\n============================================================\nCLASS %@\nSUPER %@\nIMAGE %@\n",
      name,sup?V8S(class_getName(sup)):@"(none)",V8S(class_getImageName(c))];
    unsigned int n=0;
    Ivar *ivars=class_copyIvarList(c,&n);
    [out appendFormat:@"  IVARS (%u)\n",n];
    for(unsigned int i=0;i<n;i++) {
        [out appendFormat:@"    %@ | %@ | offset=%td\n",V8S(ivar_getName(ivars[i])),
          V8S(ivar_getTypeEncoding(ivars[i])),ivar_getOffset(ivars[i])];
    }
    free(ivars);
    unsigned int propCount=0;
    objc_property_t *props=class_copyPropertyList(c,&propCount);
    [out appendFormat:@"  PROPERTIES (%u)\n",propCount];
    for(unsigned int i=0;i<propCount;i++) {
        [out appendFormat:@"    %@ | %@\n",V8S(property_getName(props[i])),V8S(property_getAttributes(props[i]))];
    }
    free(props);
    V8AppendProtocols(out,c);
    V8AppendMethodList(out,c,NO,methodTotal);
    V8AppendMethodList(out,c,YES,methodTotal);
}
static NSString *V8ReportPath(void) {
    NSArray *dirs=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    return [(dirs.firstObject?:NSTemporaryDirectory()) stringByAppendingPathComponent:@"AutoMixDiscoveryV8.txt"];
}
static NSString *V8Scan(void) {
    NSString *version=NSBundle.mainBundle.infoDictionary[@"CFBundleShortVersionString"]?:@"unknown";
    NSString *build=NSBundle.mainBundle.infoDictionary[@"CFBundleVersion"]?:@"unknown";
    NSMutableString *out=[NSMutableString stringWithFormat:
      @"AUTOMIX DISCOVERY V8 — RUNTIME CLASS / SELECTOR / PROTOCOL MAP\nBundle: %@\nVersion: %@ (%@)\nDate: %@\n",
      NSBundle.mainBundle.bundleIdentifier?:@"unknown",version,build,[NSDate date]];
    [out appendString:@"\nREAD-ONLY runtime metadata scan. Does not call Spotify playback methods, create Spotify player objects, modify audio, read audio buffers, or decrypt media. IMP addresses are reported as image-relative offsets only; they are not proof that a method is safe to hook.\n"];
    uint32_t images=_dyld_image_count();
    NSUInteger spotifyImages=0;
    [out appendFormat:@"\nLOADED DYLD IMAGES: %u\n",images];
    for(uint32_t i=0;i<images;i++) if(V8IsSpotifyImage(_dyld_get_image_name(i))) {
        spotifyImages++;
        [out appendFormat:@"  %@\n",V8S(_dyld_get_image_name(i))];
    }
    int total=objc_getClassList(NULL,0);
    Class __unsafe_unretained *classes=(Class __unsafe_unretained *)calloc((size_t)MAX(total,1),sizeof(Class));
    int filled=classes?objc_getClassList(classes,total):0;
    NSUInteger matched=0,methodTotal=0;
    [out appendString:@"\n\nFOCUSED SPOTIFY RUNTIME CLASSES\n"];
    for(int i=0;i<filled && matched<220;i++) {
        Class c=classes[i];
        if(!c || !V8IsSpotifyImage(class_getImageName(c))) continue;
        NSString *name=V8S(class_getName(c));
        if(V8ContainsAny(name,V8FocusTerms())) {
            V8AppendClass(out,c,&methodTotal);
            matched++;
        }
    }
    free(classes);
    [out appendFormat:@"\n\nSUMMARY\nSpotify images: %lu\nRuntime classes registered: %d\nFocused classes detailed: %lu\nMethods enumerated: %lu\nReport characters before save footer: %lu\n",
      (unsigned long)spotifyImages,filled,(unsigned long)matched,(unsigned long)methodTotal,(unsigned long)out.length];
    NSError *error=nil;
    BOOL saved=[out writeToFile:V8ReportPath() atomically:YES encoding:NSUTF8StringEncoding error:&error];
    [out appendFormat:@"Saved: %@ (%@)\n",saved?@"YES":@"NO",V8ReportPath()];
    if(error)[out appendFormat:@"Save error: %@\n",error];
    return out;
}
static UIViewController *V8TopController(void) {
    UIWindow *key=nil;
    for(UIScene *scene in UIApplication.sharedApplication.connectedScenes) {
        if(![scene isKindOfClass:UIWindowScene.class] || scene.activationState!=UISceneActivationStateForegroundActive) continue;
        for(UIWindow *window in ((UIWindowScene *)scene).windows) if(window.isKeyWindow){key=window;break;}
        if(key)break;
    }
    UIViewController *vc=key.rootViewController;
    while(vc.presentedViewController)vc=vc.presentedViewController;
    if([vc isKindOfClass:UINavigationController.class])vc=((UINavigationController *)vc).visibleViewController;
    if([vc isKindOfClass:UITabBarController.class])vc=((UITabBarController *)vc).selectedViewController;
    return vc;
}
static void V8RunScan(void) {
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED,0), ^{
        NSString *report=V8Scan();
        dispatch_async(dispatch_get_main_queue(), ^{
            UIViewController *vc=V8TopController();
            if(!vc){NSLog(@"[AutoMixDiscoveryV8] Report saved at %@",V8ReportPath());return;}
            UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"AutoMix Discovery V8"
              message:[NSString stringWithFormat:@"Runtime map complete. Report saved to Documents/AutoMixDiscoveryV8.txt (%lu characters).",(unsigned long)report.length]
              preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"Copy Full Report" style:UIAlertActionStyleDefault handler:^(__unused UIAlertAction *a){UIPasteboard.generalPasteboard.string=report;}]];
            [alert addAction:[UIAlertAction actionWithTitle:@"Share Report" style:UIAlertActionStyleDefault handler:^(__unused UIAlertAction *a){
                UIActivityViewController *share=[[UIActivityViewController alloc]initWithActivityItems:@[[NSURL fileURLWithPath:V8ReportPath()]] applicationActivities:nil];
                if(share.popoverPresentationController)share.popoverPresentationController.sourceView=vc.view;
                [vc presentViewController:share animated:YES completion:nil];
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleCancel handler:nil]];
            [vc presentViewController:alert animated:YES completion:nil];
        });
    });
}
__attribute__((constructor)) static void AutoMixDiscoveryV8(void) {
    @autoreleasepool {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,(int64_t)(8*NSEC_PER_SEC)),dispatch_get_main_queue(), ^{
            UIWindow *key=nil;
            for(UIScene *scene in UIApplication.sharedApplication.connectedScenes) {
                if(![scene isKindOfClass:UIWindowScene.class] || scene.activationState!=UISceneActivationStateForegroundActive)continue;
                for(UIWindow *window in ((UIWindowScene *)scene).windows)if(window.isKeyWindow){key=window;break;}
                if(key)break;
            }
            if(!key)return;
            UIButton *button=[UIButton buttonWithType:UIButtonTypeSystem];
            button.frame=CGRectMake(MAX(12,key.bounds.size.width-112),MAX(90,key.bounds.size.height-198),100,46);
            button.autoresizingMask=UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin;
            button.backgroundColor=[UIColor colorWithRed:.12 green:.43 blue:.78 alpha:.97];
            [button setTitle:@"SCAN V8" forState:UIControlStateNormal];
            [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
            button.titleLabel.font=[UIFont boldSystemFontOfSize:14];
            button.layer.cornerRadius=11;
            [button addAction:[UIAction actionWithHandler:^(__unused UIAction *action){V8RunScan();}] forControlEvents:UIControlEventTouchUpInside];
            [key addSubview:button];
        });
    }
}
