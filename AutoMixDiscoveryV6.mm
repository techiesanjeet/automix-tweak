#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import <dispatch/dispatch.h>

static NSString *AMSafe(const char *s) { return s ? [NSString stringWithUTF8String:s] : @""; }
static BOOL AMHas(NSString *s, NSArray<NSString *> *terms) {
    NSString *v = s.lowercaseString;
    for (NSString *t in terms) if ([v containsString:t]) return YES;
    return NO;
}
static BOOL AMIsSpotifyImage(Class c) {
    const char *p = class_getImageName(c);
    NSString *image = AMSafe(p).lowercaseString;
    return [image containsString:@"spotify.app/"] || [image containsString:@"/spotify"];
}
static NSArray<NSString *> *AMClassTerms(void) {
    return @[@"automix",@"mixing",@"crossfade",@"cross-fade",@"transition",@"multiplayer",
      @"multi_player",@"playerpool",@"player_pool",@"internalplayer",@"playergroup",
      @"audiocoordinator",@"audiotap",@"overlap",@"deck",@"playback",@"tracklist",
      @"playerimpl",@"playerfactory",@"sessionimpl",@"preset",@"preview",@"transitionloader",
      @"evaluator",@"audioengine",@"render",@"mixer",@"mix"];
}
static NSArray<NSString *> *AMMethodTerms(void) {
    return @[@"automix",@"mix",@"transition",@"overlap",@"crossfade",@"cross-fade",@"player",
      @"play",@"pause",@"stop",@"seek",@"audio",@"mute",@"volume",@"gain",@"fade",@"deck",
      @"track",@"session",@"pool",@"render",@"output",@"start",@"prepare",@"activate",
      @"deactivate",@"create",@"factory",@"load",@"duration",@"time",@"rate",@"pitch",@"beat",
      @"bpm",@"synchronize",@"sync",@"subject",@"group",@"tap",@"buffer",@"stream",@"preset"];
}
static void AMAppendClass(NSMutableString *out, Class cls) {
    NSString *name = AMSafe(class_getName(cls));
    [out appendFormat:@"\n\n================ CLASS %@ ================\nIMAGE %@\n",
      name, AMSafe(class_getImageName(cls))];
    Class parent = class_getSuperclass(cls);
    [out appendFormat:@"SUPERCLASS %@\n", parent ? AMSafe(class_getName(parent)) : @"(none)"];
    unsigned int n = 0;
    Ivar *iv = class_copyIvarList(cls, &n);
    [out appendFormat:@"IVARS (%u)\n", n];
    for (unsigned int i=0;i<n;i++) [out appendFormat:@"  %@ | encoding=%@ | offset=%td\n",
      AMSafe(ivar_getName(iv[i])), AMSafe(ivar_getTypeEncoding(iv[i])), ivar_getOffset(iv[i])];
    free(iv);
    objc_property_t *pr = class_copyPropertyList(cls, &n);
    [out appendFormat:@"PROPERTIES (%u)\n", n];
    for (unsigned int i=0;i<n;i++) [out appendFormat:@"  %@ | attrs=%@\n",
      AMSafe(property_getName(pr[i])), AMSafe(property_getAttributes(pr[i]))];
    free(pr);
    Protocol *__unsafe_unretained *pp = class_copyProtocolList(cls, &n);
    [out appendFormat:@"DIRECT PROTOCOLS (%u)\n", n];
    for (unsigned int i=0;i<n;i++) [out appendFormat:@"  %@\n", AMSafe(protocol_getName(pp[i]))];
    free(pp);
    NSArray *terms = AMMethodTerms();
    Method *m = class_copyMethodList(cls, &n);
    NSMutableArray *matched = [NSMutableArray array];
    for (unsigned int i=0;i<n;i++) {
        NSString *sel = NSStringFromSelector(method_getName(m[i]));
        if (AMHas(sel, terms)) [matched addObject:[NSString stringWithFormat:@"  %@ | encoding=%@",
          sel, AMSafe(method_getTypeEncoding(m[i]))]];
    }
    [out appendFormat:@"RELEVANT DIRECT INSTANCE METHODS (%lu of %u)\n%@\n",
      (unsigned long)matched.count, n, [matched componentsJoinedByString:@"\n"]];
    free(m);
    Method *cm = class_copyMethodList(object_getClass(cls), &n);
    NSMutableArray *cmatched = [NSMutableArray array];
    for (unsigned int i=0;i<n;i++) {
        NSString *sel = NSStringFromSelector(method_getName(cm[i]));
        if (AMHas(sel, terms)) [cmatched addObject:[NSString stringWithFormat:@"  %@ | encoding=%@",
          sel, AMSafe(method_getTypeEncoding(cm[i]))]];
    }
    [out appendFormat:@"RELEVANT DIRECT CLASS METHODS (%lu of %u)\n%@\n",
      (unsigned long)cmatched.count, n, [cmatched componentsJoinedByString:@"\n"]];
    free(cm);
}
static NSString *AMReportPath(void) {
    NSArray *dirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [(dirs.firstObject ?: NSTemporaryDirectory()) stringByAppendingPathComponent:@"AutoMixDiscoveryV6.txt"];
}
static NSString *AMScan(void) {
    int total = objc_getClassList(NULL, 0);
    if (total <= 0) return @"Runtime class enumeration failed.";
    Class __unsafe_unretained *classes = (Class __unsafe_unretained *)calloc((size_t)total, sizeof(Class));
    if (!classes) return @"Runtime class allocation failed.";
    int filled = objc_getClassList(classes, total);
    NSMutableArray<Class> *targets = [NSMutableArray array];
    NSMutableArray<NSString *> *names = [NSMutableArray array];
    NSArray *terms = AMClassTerms();
    for (int i=0;i<filled;i++) {
        Class c = classes[i];
        if (!c || !AMIsSpotifyImage(c)) continue;
        NSString *name = AMSafe(class_getName(c));
        if (AMHas(name, terms)) { [targets addObject:c]; [names addObject:name]; }
    }
    [names sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    [targets sortUsingComparator:^NSComparisonResult(Class a, Class b) {
        return [AMSafe(class_getName(a)) localizedCaseInsensitiveCompare:AMSafe(class_getName(b))];
    }];
    NSMutableString *report = [NSMutableString stringWithFormat:
      @"AUTOMIX DISCOVERY V6 — SPOTIFY-ONLY DEEP METADATA\nBundle: %@\nApp version: %@\nBuild: %@\nDate: %@\n"
      @"Runtime classes enumerated: %d\nSpotify image classes: filtered by class_getImageName()\nMatched relevant classes: %lu\n\n"
      @"READ-ONLY: This scan enumerates runtime class metadata. It does not instantiate Spotify objects, call Spotify methods, "
      @"inspect audio buffers, decode protected media, or access track contents.\n"
      @"Objective-C runtime metadata does not expose all Swift method bodies or necessarily all Swift types. "
      @"Presence of a player pool or transition type is not proof of dual audible playback.\n\n"
      @"========== TARGET CLASS INDEX ==========\n%@\n",
      NSBundle.mainBundle.bundleIdentifier ?: @"unknown",
      NSBundle.mainBundle.infoDictionary[@"CFBundleShortVersionString"] ?: @"unknown",
      NSBundle.mainBundle.infoDictionary[@"CFBundleVersion"] ?: @"unknown",
      [NSDate date], filled, (unsigned long)targets.count, [names componentsJoinedByString:@"\n"]];
    for (Class c in targets) AMAppendClass(report, c);
    [report appendFormat:@"\n\n========== SCAN SUMMARY ==========\nTarget classes inspected: %lu\nReport characters: %lu\n",
      (unsigned long)targets.count, (unsigned long)report.length];
    NSError *error = nil;
    BOOL ok = [report writeToFile:AMReportPath() atomically:YES encoding:NSUTF8StringEncoding error:&error];
    [report appendFormat:@"\nReport file write: %@ (%@)\n", ok ? @"SUCCESS" : @"FAILED", AMReportPath()];
    if (error) [report appendFormat:@"Write error: %@\n", error];
    free(classes);
    return report;
}
static UIViewController *AMTopController(void) {
    UIWindow *window = nil;
    for (UIScene *scene in UIApplication.sharedApplication.connectedScenes) {
        if (scene.activationState != UISceneActivationStateForegroundActive) continue;
        if ([scene isKindOfClass:UIWindowScene.class]) {
            for (UIWindow *w in ((UIWindowScene *)scene).windows) if (w.isKeyWindow) { window=w; break; }
        }
        if (window) break;
    }
    UIViewController *vc = window.rootViewController;
    while (vc.presentedViewController) vc = vc.presentedViewController;
    if ([vc isKindOfClass:UINavigationController.class]) vc=((UINavigationController *)vc).visibleViewController;
    if ([vc isKindOfClass:UITabBarController.class]) vc=((UITabBarController *)vc).selectedViewController;
    return vc;
}
static void AMShowReport(UIViewController *vc, NSString *report) {
    UIAlertController *a = [UIAlertController alertControllerWithTitle:@"AutoMix Discovery V6"
      message:[NSString stringWithFormat:@"Scan complete. Report saved to Documents/AutoMixDiscoveryV6.txt\n\n%lu characters.",
        (unsigned long)report.length] preferredStyle:UIAlertControllerStyleAlert];
    [a addAction:[UIAlertAction actionWithTitle:@"Copy Report" style:UIAlertActionStyleDefault handler:^(__unused UIAlertAction *x) {
      UIPasteboard.generalPasteboard.string = report;
      UIAlertController *done=[UIAlertController alertControllerWithTitle:@"Copied" message:@"Full report copied to clipboard." preferredStyle:UIAlertControllerStyleAlert];
      [done addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
      [vc presentViewController:done animated:YES completion:nil];
    }]];
    [a addAction:[UIAlertAction actionWithTitle:@"Share Report" style:UIAlertActionStyleDefault handler:^(__unused UIAlertAction *x) {
      NSURL *url=[NSURL fileURLWithPath:AMReportPath()];
      UIActivityViewController *activity=[[UIActivityViewController alloc] initWithActivityItems:@[url] applicationActivities:nil];
      if (activity.popoverPresentationController) activity.popoverPresentationController.sourceView=vc.view;
      [vc presentViewController:activity animated:YES completion:nil];
    }]];
    [a addAction:[UIAlertAction actionWithTitle:@"View Report" style:UIAlertActionStyleDefault handler:^(__unused UIAlertAction *x) {
      UIAlertController *viewer=[UIAlertController alertControllerWithTitle:@"Report Preview"
        message:[report substringToIndex:MIN(report.length,(NSUInteger)3500)] preferredStyle:UIAlertControllerStyleAlert];
      [viewer addAction:[UIAlertAction actionWithTitle:@"Copy Full Report" style:UIAlertActionStyleDefault handler:^(__unused UIAlertAction *y) {
        UIPasteboard.generalPasteboard.string=report;
      }]];
      [viewer addAction:[UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleCancel handler:nil]];
      [vc presentViewController:viewer animated:YES completion:nil];
    }]];
    [a addAction:[UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleCancel handler:nil]];
    [vc presentViewController:a animated:YES completion:nil];
}
static void AMRunScan(void) {
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED,0), ^{
      NSString *report=AMScan();
      dispatch_async(dispatch_get_main_queue(), ^{
        UIViewController *vc=AMTopController();
        if (vc) AMShowReport(vc,report);
        else NSLog(@"[AutoMixDiscoveryV6] %@", AMReportPath());
      });
    });
}
__attribute__((constructor)) static void AutoMixDiscoveryV6(void) {
    @autoreleasepool {
      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(7*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *window=nil;
        for (UIScene *scene in UIApplication.sharedApplication.connectedScenes) {
          if (![scene isKindOfClass:UIWindowScene.class] || scene.activationState!=UISceneActivationStateForegroundActive) continue;
          for (UIWindow *w in ((UIWindowScene *)scene).windows) if (w.isKeyWindow) {window=w;break;}
          if (window) break;
        }
        if (!window) { AMRunScan(); return; }
        UIButton *button=[UIButton buttonWithType:UIButtonTypeSystem];
        button.frame=CGRectMake(MAX(12,window.bounds.size.width-104),MAX(90,window.bounds.size.height-190),92,44);
        button.autoresizingMask=UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin;
        button.backgroundColor=[UIColor colorWithRed:0.12 green:0.55 blue:0.95 alpha:0.95];
        [button setTitle:@"SCAN MIX" forState:UIControlStateNormal];
        [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        button.titleLabel.font=[UIFont boldSystemFontOfSize:14];
        button.layer.cornerRadius=12;
        button.layer.shadowOpacity=0.25;
        button.layer.shadowRadius=5;
        button.layer.shadowOffset=CGSizeMake(0,2);
        [button addTarget:[NSBlockOperation blockOperationWithBlock:^{ AMRunScan(); }] action:@selector(main) forControlEvents:UIControlEventTouchUpInside];
        // Retain a direct target to keep the control alive.
        id target=[button.allTargets anyObject];
        objc_setAssociatedObject(button, @selector(AMRunScan), target, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [window addSubview:button];
        NSLog(@"[AutoMixDiscoveryV6] SCAN MIX control added");
      });
    }
}
