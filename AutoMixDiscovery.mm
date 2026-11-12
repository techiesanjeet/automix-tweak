#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <mach-o/dyld.h>

static NSString * const kReportName = @"AutoMix-Spotify-Discovery-v3.txt";

static BOOL AMIsTarget(NSString *name) {
    NSString *s = name.lowercaseString;
    return [s containsString:@"playlistmixing_"] ||
           [s containsString:@"spotify_automix_"] ||
           [s containsString:@"multiplayer_"] ||
           [s containsString:@"nowplaying_mixingtransition"] ||
           [s containsString:@"crossfade"] ||
           [s containsString:@"automixtransition"] ||
           [s containsString:@"transitionplayer"] ||
           [s containsString:@"playergroup"] ||
           [s containsString:@"internalplayer"];
}

static NSString *AMPath(void) {
    NSString *d = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    return [d stringByAppendingPathComponent:kReportName];
}

static void AMMethods(NSMutableString *out, Class cls, BOOL classMethods) {
    unsigned int n = 0;
    Method *list = class_copyMethodList(classMethods ? object_getClass(cls) : cls, &n);
    NSUInteger shown = 0;
    for (unsigned int i = 0; list && i < n && shown < 22; i++) {
        const char *sel = sel_getName(method_getName(list[i]));
        if (sel) { [out appendFormat:@"  %@ %s\n", classMethods ? @"+" : @"-", sel]; shown++; }
    }
    if (n > shown) [out appendFormat:@"  ... %u more\n", (unsigned)(n - shown)];
    if (list) free(list);
    if (!n) [out appendString:@"  (none exposed)\n"];
}

static void AMDescribe(NSMutableString *out, Class cls) {
    const char *raw = class_getName(cls);
    if (!raw) return;
    NSString *name = [NSString stringWithUTF8String:raw];
    const char *img = class_getImageName(cls);
    [out appendFormat:@"\n## %@\nImage: %@\n", name, img ? [NSString stringWithUTF8String:img] : @"?"];
    Class sup = class_getSuperclass(cls);
    [out appendFormat:@"Superclass: %@\n", sup ? NSStringFromClass(sup) : @"(none)"];

    unsigned int n = 0;
    Ivar *iv = class_copyIvarList(cls, &n);
    [out appendFormat:@"Ivars (%u):\n", n];
    for (unsigned int i = 0; iv && i < n && i < 24; i++) {
        const char *vn = ivar_getName(iv[i]), *vt = ivar_getTypeEncoding(iv[i]);
        [out appendFormat:@"  %s : %s\n", vn ?: "?", vt ?: "?"];
    }
    if (iv) free(iv);

    objc_property_t *props = class_copyPropertyList(cls, &n);
    [out appendFormat:@"Properties (%u):\n", n];
    for (unsigned int i = 0; props && i < n && i < 18; i++) {
        const char *pn = property_getName(props[i]), *pa = property_getAttributes(props[i]);
        [out appendFormat:@"  %s [%s]\n", pn ?: "?", pa ?: "?"];
    }
    if (props) free(props);

    Protocol *__unsafe_unretained *protocols = class_copyProtocolList(cls, &n);
    [out appendFormat:@"Protocols (%u):\n", n];
    for (unsigned int i = 0; protocols && i < n && i < 18; i++) {
        const char *pn = protocol_getName(protocols[i]);
        if (pn) [out appendFormat:@"  %s\n", pn];
    }
    if (protocols) free(protocols);

    [out appendString:@"Instance selectors:\n"]; AMMethods(out, cls, NO);
    [out appendString:@"Class selectors:\n"]; AMMethods(out, cls, YES);
}

static NSString *AMReport(void) {
    NSMutableString *out = [NSMutableString string];
    [out appendString:@"AUTOMIX TARGETED DISCOVERY V3\n"];
    [out appendFormat:@"Bundle: %@\nVersion: %@ (%@)\n",
     NSBundle.mainBundle.bundleIdentifier ?: @"?",
     NSBundle.mainBundle.infoDictionary[@"CFBundleShortVersionString"] ?: @"?",
     NSBundle.mainBundle.infoDictionary[@"CFBundleVersion"] ?: @"?"];
    [out appendFormat:@"Date: %@\n", [NSDate date]];
    [out appendString:@"Metadata-only. No Spotify methods invoked; no audio buffers or media contents read.\n"];
    int total = objc_getClassList(NULL, 0);
    if (total <= 0) return [out stringByAppendingString:@"No Objective-C classes returned.\n"];
    Class *classes = (Class *)calloc((size_t)total, sizeof(Class));
    int actual = objc_getClassList(classes, total);
    NSMutableArray<NSString *> *names = [NSMutableArray array];
    NSMutableDictionary<NSString *, NSValue *> *map = [NSMutableDictionary dictionary];
    for (int i = 0; i < actual; i++) {
        const char *raw = class_getName(classes[i]);
        if (!raw) continue;
        NSString *name = [NSString stringWithUTF8String:raw];
        if (AMIsTarget(name)) {
            [names addObject:name];
            map[name] = [NSValue valueWithPointer:(__bridge const void *)classes[i]];
        }
    }
    [names sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    [out appendFormat:@"Runtime classes scanned: %d\nTarget classes: %lu\n\nTARGET CLASS INDEX:\n",
     actual, (unsigned long)names.count];
    for (NSString *name in names) [out appendFormat:@"%@\n", name];
    [out appendString:@"\nTARGETED METADATA:\n"];
    NSUInteger limit = MIN((NSUInteger)100, names.count);
    for (NSUInteger i = 0; i < limit; i++) {
        Class cls = (__bridge Class)[map[names[i]] pointerValue];
        AMDescribe(out, cls);
        if (out.length > 70000) {
            [out appendString:@"\nSIZE CAP REACHED; remaining details omitted.\n"];
            break;
        }
    }
    if (names.count > limit) [out appendFormat:@"\n%lu classes omitted from details.\n", (unsigned long)(names.count-limit)];
    free(classes);
    return out;
}

static void AMWriteReport(void) {
    @autoreleasepool {
        NSString *s = AMReport();
        NSError *e = nil;
        BOOL ok = [s writeToFile:AMPath() atomically:YES encoding:NSUTF8StringEncoding error:&e];
        NSLog(@"[AutoMixDiscoveryV3] %@; %lu chars; %@", ok ? @"saved" : @"failed",
              (unsigned long)s.length, e.localizedDescription ?: AMPath());
    }
}

@interface AMV3Button : NSObject
@property(nonatomic,strong) UIButton *button;
+ (instancetype)shared;
- (void)install;
@end

@implementation AMV3Button
+ (instancetype)shared {
    static AMV3Button *v; static dispatch_once_t once;
    dispatch_once(&once, ^{ v = [AMV3Button new]; }); return v;
}
- (UIWindow *)window {
    for (UIScene *scene in UIApplication.sharedApplication.connectedScenes) {
        if (scene.activationState != UISceneActivationStateForegroundActive || ![scene isKindOfClass:UIWindowScene.class]) continue;
        for (UIWindow *w in ((UIWindowScene *)scene).windows) if (w.isKeyWindow) return w;
    }
    return UIApplication.sharedApplication.windows.firstObject;
}
- (void)install {
    if (self.button) return;
    UIWindow *w = [self window];
    if (!w) { dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2*NSEC_PER_SEC), dispatch_get_main_queue(), ^{ [self install]; }); return; }
    self.button = [UIButton buttonWithType:UIButtonTypeSystem];
    self.button.frame = CGRectMake(MAX(8, w.bounds.size.width-124), 198, 116, 38);
    self.button.backgroundColor = [UIColor colorWithRed:.1 green:.8 blue:.55 alpha:.96];
    [self.button setTitle:@"AUTOMIX SCAN V3" forState:UIControlStateNormal];
    [self.button setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    self.button.titleLabel.font = [UIFont boldSystemFontOfSize:10];
    self.button.layer.cornerRadius = 9;
    [self.button addTarget:self action:@selector(scan) forControlEvents:UIControlEventTouchUpInside];
    [w addSubview:self.button];
}
- (void)scan {
    self.button.enabled = NO; [self.button setTitle:@"SCANNING..." forState:UIControlStateNormal];
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_UTILITY,0), ^{
        AMWriteReport();
        dispatch_async(dispatch_get_main_queue(), ^{
            self.button.enabled = YES; [self.button setTitle:@"AUTOMIX SCAN V3" forState:UIControlStateNormal];
            NSURL *url = [NSURL fileURLWithPath:AMPath()];
            UIActivityViewController *a = [[UIActivityViewController alloc] initWithActivityItems:@[url] applicationActivities:nil];
            UIViewController *p = [self window].rootViewController;
            while (p.presentedViewController) p = p.presentedViewController;
            if (a.popoverPresentationController) { a.popoverPresentationController.sourceView=self.button; a.popoverPresentationController.sourceRect=self.button.bounds; }
            if (p) [p presentViewController:a animated:YES completion:nil];
        });
    });
}
@end

__attribute__((constructor)) static void AMV3Init(void) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 15*NSEC_PER_SEC), dispatch_get_main_queue(), ^{ [[AMV3Button shared] install]; });
}
