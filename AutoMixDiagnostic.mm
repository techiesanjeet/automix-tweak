#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <mach-o/dyld.h>
#import <mach-o/loader.h>

static NSString * const AMTargetKeywords[] = {
    @"PlaylistMixing_TransitionPlayerImpl",
    @"PlaylistMixing_MixingImpl",
    @"PlaylistMixing_MixingUIImpl",
    @"PlaylistMixing_WaveformKit",
    @"WatchFeed_WatchFeedFeatureImpl",
    @"NowPlaying_ViewImpl"
};

static void AMAppend(NSMutableString *out, NSString *line) {
    if (out.length < 48000) {
        [out appendFormat:@"%@\n", line ?: @""];
    }
}

static NSString *AMString(const char *value) {
    return value ? [NSString stringWithUTF8String:value] : @"<null>";
}

static BOOL AMIsTarget(NSString *name) {
    for (NSUInteger i = 0; i < sizeof(AMTargetKeywords) / sizeof(AMTargetKeywords[0]); i++) {
        if ([name containsString:AMTargetKeywords[i]]) return YES;
    }
    return NO;
}

static void AMDumpClass(NSMutableString *out, Class cls) {
    NSString *name = AMString(class_getName(cls));
    const char *image = class_getImageName(cls);
    AMAppend(out, @"");
    AMAppend(out, [NSString stringWithFormat:@"========== %@ ==========", name]);
    AMAppend(out, [NSString stringWithFormat:@"Image: %@", AMString(image)]);
    Class superClass = class_getSuperclass(cls);
    AMAppend(out, [NSString stringWithFormat:@"Superclass: %@", superClass ? AMString(class_getName(superClass)) : @"<none>"]);

    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList(cls, &count);
    AMAppend(out, [NSString stringWithFormat:@"Instance variables (%u):", count]);
    for (unsigned int i = 0; i < count && i < 100; i++) {
        AMAppend(out, [NSString stringWithFormat:@"  %s : %s",
                       ivar_getName(ivars[i]), ivar_getTypeEncoding(ivars[i]) ?: "?"]);
    }
    free(ivars);

    count = 0;
    objc_property_t *properties = class_copyPropertyList(cls, &count);
    AMAppend(out, [NSString stringWithFormat:@"Properties (%u):", count]);
    for (unsigned int i = 0; i < count && i < 100; i++) {
        AMAppend(out, [NSString stringWithFormat:@"  %s  [%s]",
                       property_getName(properties[i]), property_getAttributes(properties[i]) ?: "?"]);
    }
    free(properties);

    count = 0;
    Method *methods = class_copyMethodList(cls, &count);
    AMAppend(out, [NSString stringWithFormat:@"Own methods (%u):", count]);
    for (unsigned int i = 0; i < count && i < 250; i++) {
        SEL selector = method_getName(methods[i]);
        AMAppend(out, [NSString stringWithFormat:@"  - %@  types=%s",
                       NSStringFromSelector(selector), method_getTypeEncoding(methods[i]) ?: "?"]);
    }
    free(methods);

    count = 0;
    Method *classMethods = class_copyMethodList(object_getClass(cls), &count);
    AMAppend(out, [NSString stringWithFormat:@"Own class methods (%u):", count]);
    for (unsigned int i = 0; i < count && i < 150; i++) {
        SEL selector = method_getName(classMethods[i]);
        AMAppend(out, [NSString stringWithFormat:@"  + %@  types=%s",
                       NSStringFromSelector(selector), method_getTypeEncoding(classMethods[i]) ?: "?"]);
    }
    free(classMethods);
}

static NSString *AMBuildReport(void) {
    NSMutableString *out = [NSMutableString string];
    AMAppend(out, @"AUTOMIX TARGETED PLAYLIST-MIXING DIAGNOSTIC");
    AMAppend(out, [NSString stringWithFormat:@"Bundle: %@", NSBundle.mainBundle.bundleIdentifier ?: @"unknown"]);
    AMAppend(out, [NSString stringWithFormat:@"Version: %@ (%@)",
                   NSBundle.mainBundle.infoDictionary[@"CFBundleShortVersionString"] ?: @"unknown",
                   NSBundle.mainBundle.infoDictionary[@"CFBundleVersion"] ?: @"unknown"]);
    AMAppend(out, [NSString stringWithFormat:@"Timestamp: %@", [NSDate date]]);
    AMAppend(out, @"");
    AMAppend(out, @"This diagnostic reads Objective-C runtime metadata only. It does not call Spotify methods or access audio data.");

    int total = objc_getClassList(NULL, 0);
    Class *classes = total > 0 ? (Class *)calloc((size_t)total, sizeof(Class)) : NULL;
    int actual = classes ? objc_getClassList(classes, total) : 0;
    NSMutableArray<NSString *> *matches = [NSMutableArray array];
    for (int i = 0; i < actual; i++) {
        NSString *name = AMString(class_getName(classes[i]));
        if (AMIsTarget(name)) [matches addObject:name];
    }
    AMAppend(out, [NSString stringWithFormat:@"Runtime classes scanned: %d", actual]);
    AMAppend(out, [NSString stringWithFormat:@"Target classes matched: %lu", (unsigned long)matches.count]);
    [matches sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];

    for (NSString *name in matches) {
        Class cls = objc_getClass(name.UTF8String);
        if (cls) AMDumpClass(out, cls);
    }
    free(classes);

    AMAppend(out, @"");
    AMAppend(out, @"RELEVANT LOADED IMAGES");
    uint32_t imageCount = _dyld_image_count();
    unsigned int shown = 0;
    for (uint32_t i = 0; i < imageCount; i++) {
        const char *path = _dyld_get_image_name(i);
        NSString *p = AMString(path);
        if ([p localizedCaseInsensitiveContainsString:@"spotify"] ||
            [p localizedCaseInsensitiveContainsString:@"playlist"] ||
            [p localizedCaseInsensitiveContainsString:@"automix"] ||
            [p localizedCaseInsensitiveContainsString:@"betamax"]) {
            AMAppend(out, [NSString stringWithFormat:@"  %@", p]);
            shown++;
        }
    }
    AMAppend(out, [NSString stringWithFormat:@"Relevant images: %u", shown]);
    AMAppend(out, @"");
    AMAppend(out, @"Interpretation note: class names and signatures identify possible interfaces, not proof that two independent music decks are active or accessible.");
    return out;
}

@interface AMDiagnosticPanel : NSObject
@property(nonatomic, strong) UIWindow *window;
@property(nonatomic, strong) UITextView *textView;
+ (instancetype)shared;
- (void)show;
@end

@implementation AMDiagnosticPanel
+ (instancetype)shared {
    static AMDiagnosticPanel *instance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{ instance = [AMDiagnosticPanel new]; });
    return instance;
}

- (void)show {
    if (self.window) return;
    UIWindowScene *activeScene = nil;
    for (UIScene *scene in UIApplication.sharedApplication.connectedScenes) {
        if ([scene isKindOfClass:UIWindowScene.class] &&
            scene.activationState == UISceneActivationStateForegroundActive) {
            activeScene = (UIWindowScene *)scene;
            break;
        }
    }
    if (!activeScene) return;

    self.window = [[UIWindow alloc] initWithWindowScene:activeScene];
    self.window.frame = activeScene.coordinateSpace.bounds;
    self.window.windowLevel = UIWindowLevelAlert + 2;
    self.window.backgroundColor = [UIColor colorWithWhite:0.04 alpha:0.97];

    UIViewController *root = [UIViewController new];
    root.view.backgroundColor = UIColor.blackColor;
    self.window.rootViewController = root;

    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(16, 48, root.view.bounds.size.width - 32, 30)];
    title.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    title.text = @"AutoMix Runtime Diagnostic";
    title.textColor = UIColor.whiteColor;
    title.font = [UIFont boldSystemFontOfSize:19];
    [root.view addSubview:title];

    UIButton *copy = [UIButton buttonWithType:UIButtonTypeSystem];
    copy.frame = CGRectMake(16, 86, 110, 38);
    [copy setTitle:@"Copy report" forState:UIControlStateNormal];
    copy.backgroundColor = [UIColor colorWithRed:0.15 green:0.42 blue:0.85 alpha:1];
    [copy setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    copy.layer.cornerRadius = 8;
    [copy addTarget:self action:@selector(copyReport) forControlEvents:UIControlEventTouchUpInside];
    [root.view addSubview:copy];

    UIButton *close = [UIButton buttonWithType:UIButtonTypeSystem];
    close.frame = CGRectMake(root.view.bounds.size.width - 96, 86, 80, 38);
    close.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [close setTitle:@"Close" forState:UIControlStateNormal];
    [close setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [close addTarget:self action:@selector(closePanel) forControlEvents:UIControlEventTouchUpInside];
    [root.view addSubview:close];

    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(12, 134, root.view.bounds.size.width - 24, root.view.bounds.size.height - 150)];
    self.textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.textView.backgroundColor = [UIColor colorWithWhite:0.10 alpha:1];
    self.textView.textColor = [UIColor colorWithWhite:0.92 alpha:1];
    self.textView.font = [UIFont monospacedSystemFontOfSize:10.5 weight:UIFontWeightRegular];
    self.textView.editable = NO;
    self.textView.text = AMBuildReport();
    [root.view addSubview:self.textView];

    [self.window makeKeyAndVisible];
}

- (void)copyReport {
    UIPasteboard.generalPasteboard.string = self.textView.text ?: @"";
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Copied"
        message:@"Paste the diagnostic report into ChatGPT."
        preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
}

- (void)closePanel {
    self.window.hidden = YES;
    self.window = nil;
}
@end

__attribute__((constructor))
static void AMDiagnosticInit(void) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(12 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
        [AMDiagnosticPanel.shared show];
    });
}
