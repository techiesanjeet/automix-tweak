#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <mach-o/dyld.h>

static NSString * const kReportName = @"AutoMix-Spotify-Discovery-v2.txt";

static NSArray<NSString *> *AMKeywords(void) {
    return @[@"player", @"audio", @"stream", @"queue", @"track", @"playback",
             @"decoder", @"render", @"engine", @"mix", @"deck", @"session",
             @"media", @"crossfade", @"automix", @"pipeline", @"buffer",
             @"stateful", @"spotify", @"remote", @"music", @"output"];
}

static BOOL AMMatches(NSString *value) {
    NSString *lower = value.lowercaseString;
    for (NSString *word in AMKeywords()) {
        if ([lower containsString:word]) return YES;
    }
    return NO;
}

static NSString *AMDocumentsPath(void) {
    NSString *docs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    return [docs stringByAppendingPathComponent:kReportName];
}

static void AMAppendMethods(NSMutableString *out, Class cls, BOOL classMethods) {
    unsigned int count = 0;
    Method *methods = class_copyMethodList(classMethods ? object_getClass(cls) : cls, &count);
    if (!methods) {
        [out appendString:@"  (no Objective-C runtime methods exposed)\n"];
        return;
    }

    unsigned int emitted = 0;
    for (unsigned int i = 0; i < count && emitted < 35; i++) {
        SEL selector = method_getName(methods[i]);
        const char *name = sel_getName(selector);
        if (name) {
            [out appendFormat:@"  %@ %s\n", classMethods ? @"+" : @"-", name];
            emitted++;
        }
    }
    if (count > emitted) [out appendFormat:@"  ... %u additional methods omitted\n", count - emitted];
    free(methods);
}

static void AMAppendClass(NSMutableString *out, Class cls) {
    const char *rawName = class_getName(cls);
    if (!rawName) return;

    NSString *name = [NSString stringWithUTF8String:rawName];
    const char *rawImage = class_getImageName(cls);
    NSString *imagePath = rawImage ? [NSString stringWithUTF8String:rawImage] : @"(image unavailable)";
    Class superClass = class_getSuperclass(cls);
    NSString *superName = superClass ? NSStringFromClass(superClass) : @"(none)";

    [out appendFormat:@"\n========== %@ ==========\nImage: %@\nSuperclass: %@\n", name, imagePath, superName];

    unsigned int ivarCount = 0;
    Ivar *ivars = class_copyIvarList(cls, &ivarCount);
    [out appendFormat:@"Instance variables (%u):\n", ivarCount];
    for (unsigned int i = 0; i < ivarCount && i < 50; i++) {
        const char *ivarName = ivar_getName(ivars[i]);
        const char *type = ivar_getTypeEncoding(ivars[i]);
        [out appendFormat:@"  %s : %s\n", ivarName ?: "?", type ?: "?"];
    }
    if (ivarCount > 50) [out appendFormat:@"  ... %u additional ivars omitted\n", ivarCount - 50];
    free(ivars);

    unsigned int propertyCount = 0;
    objc_property_t *properties = class_copyPropertyList(cls, &propertyCount);
    [out appendFormat:@"Properties (%u):\n", propertyCount];
    for (unsigned int i = 0; i < propertyCount && i < 35; i++) {
        const char *propertyName = property_getName(properties[i]);
        const char *attributes = property_getAttributes(properties[i]);
        [out appendFormat:@"  %s [%s]\n", propertyName ?: "?", attributes ?: "?"];
    }
    free(properties);

    [out appendFormat:@"Instance methods:\n"];
    AMAppendMethods(out, cls, NO);
    [out appendFormat:@"Class methods:\n"];
    AMAppendMethods(out, cls, YES);
}

static NSString *AMBuildReport(void) {
    NSMutableString *out = [NSMutableString string];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss 'UTC'";

    [out appendString:@"AUTOMIX TARGETED PLAYBACK DISCOVERY V2\n"];
    [out appendFormat:@"Bundle: %@\n", NSBundle.mainBundle.bundleIdentifier ?: @"unknown"];
    [out appendFormat:@"Version: %@ (%@)\n",
     NSBundle.mainBundle.infoDictionary[@"CFBundleShortVersionString"] ?: @"unknown",
     NSBundle.mainBundle.infoDictionary[@"CFBundleVersion"] ?: @"unknown"];
    [out appendFormat:@"Timestamp: %@\n", [formatter stringFromDate:[NSDate date]]];
    [out appendString:@"Metadata-only scan: no Spotify methods are invoked; no audio buffers, decoded media, credentials, or track contents are read.\n\n"];

    uint32_t imageCount = _dyld_image_count();
    [out appendFormat:@"Loaded Mach-O images: %u\n", imageCount];
    [out appendString:@"Relevant loaded images:\n"];
    unsigned int relevantImages = 0;
    for (uint32_t i = 0; i < imageCount; i++) {
        const char *path = _dyld_get_image_name(i);
        if (!path) continue;
        NSString *image = [NSString stringWithUTF8String:path];
        if (AMMatches(image)) {
            [out appendFormat:@"  %@\n", image];
            relevantImages++;
        }
    }
    [out appendFormat:@"Relevant image count: %u\n\n", relevantImages];

    int total = objc_getClassList(NULL, 0);
    if (total <= 0) {
        [out appendString:@"Objective-C runtime returned no classes.\n"];
        return out;
    }

    Class *classes = (Class *)calloc((size_t)total, sizeof(Class));
    int actual = objc_getClassList(classes, total);
    [out appendFormat:@"Runtime classes scanned: %d\n", actual];

    NSMutableArray<NSString *> *matchedNames = [NSMutableArray array];
    NSMutableDictionary<NSString *, NSValue *> *classByName = [NSMutableDictionary dictionary];

    for (int i = 0; i < actual; i++) {
        const char *raw = class_getName(classes[i]);
        if (!raw) continue;
        NSString *name = [NSString stringWithUTF8String:raw];
        if (AMMatches(name)) {
            [matchedNames addObject:name];
            classByName[name] = [NSValue valueWithPointer:(__bridge const void *)classes[i]];
        }
    }

    [matchedNames sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    [out appendFormat:@"Target classes matched: %lu\n", (unsigned long)matchedNames.count];
    [out appendString:@"\nCLASS INDEX (all matches):\n"];
    for (NSString *name in matchedNames) [out appendFormat:@"  %@\n", name];

    [out appendString:@"\nDETAILED METADATA (up to 450 classes; class names, image paths, ivars, properties and selectors only):\n"];
    NSUInteger detailCount = MIN((NSUInteger)450, matchedNames.count);
    for (NSUInteger i = 0; i < detailCount; i++) {
        Class cls = (__bridge Class)[classByName[matchedNames[i]] pointerValue];
        AMAppendClass(out, cls);
        if (out.length > 1800000) {
            [out appendString:@"\nREPORT SIZE LIMIT REACHED; remaining class details omitted.\n"];
            break;
        }
    }
    if (matchedNames.count > detailCount) {
        [out appendFormat:@"\n%lu matching classes omitted from detailed section due to safety/output limit.\n",
         (unsigned long)(matchedNames.count - detailCount)];
    }

    free(classes);
    return out;
}

static void AMRunScan(void) {
    @autoreleasepool {
        NSString *report = AMBuildReport();
        NSError *error = nil;
        BOOL ok = [report writeToFile:AMDocumentsPath()
                           atomically:YES
                             encoding:NSUTF8StringEncoding
                                error:&error];
        NSLog(@"[AutoMixDiscoveryV2] %@ (%lu chars) %@",
              ok ? @"Report saved" : @"Report save failed",
              (unsigned long)report.length,
              error.localizedDescription ?: AMDocumentsPath());
    }
}

@interface AMDiscoveryButton : NSObject
@property(nonatomic, strong) UIButton *button;
+ (instancetype)shared;
- (void)install;
@end

@implementation AMDiscoveryButton

+ (instancetype)shared {
    static AMDiscoveryButton *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{ instance = [AMDiscoveryButton new]; });
    return instance;
}

- (UIWindow *)activeWindow {
    for (UIScene *scene in UIApplication.sharedApplication.connectedScenes) {
        if (scene.activationState != UISceneActivationStateForegroundActive) continue;
        if (![scene isKindOfClass:UIWindowScene.class]) continue;
        for (UIWindow *window in ((UIWindowScene *)scene).windows) {
            if (window.isKeyWindow) return window;
        }
    }
    return UIApplication.sharedApplication.windows.firstObject;
}

- (void)install {
    if (self.button) return;
    UIWindow *window = [self activeWindow];
    if (!window) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)),
                       dispatch_get_main_queue(), ^{ [self install]; });
        return;
    }

    self.button = [UIButton buttonWithType:UIButtonTypeSystem];
    self.button.frame = CGRectMake(MAX(8, window.bounds.size.width - 118), 155, 108, 36);
    self.button.backgroundColor = [UIColor colorWithRed:0.10 green:0.72 blue:0.34 alpha:0.96];
    [self.button setTitle:@"SCAN + SHARE" forState:UIControlStateNormal];
    [self.button setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    self.button.titleLabel.font = [UIFont boldSystemFontOfSize:11];
    self.button.layer.cornerRadius = 10;
    [self.button addTarget:self action:@selector(scanAndShare) forControlEvents:UIControlEventTouchUpInside];
    [window addSubview:self.button];
}

- (void)scanAndShare {
    self.button.enabled = NO;
    [self.button setTitle:@"SCANNING..." forState:UIControlStateNormal];

    dispatch_async(dispatch_get_global_queue(QOS_CLASS_UTILITY, 0), ^{
        AMRunScan();
        dispatch_async(dispatch_get_main_queue(), ^{
            self.button.enabled = YES;
            [self.button setTitle:@"SCAN + SHARE" forState:UIControlStateNormal];

            NSString *path = AMDocumentsPath();
            NSURL *url = [NSURL fileURLWithPath:path];
            UIActivityViewController *activity =
                [[UIActivityViewController alloc] initWithActivityItems:@[url] applicationActivities:nil];

            UIWindow *window = [self activeWindow];
            UIViewController *presenter = window.rootViewController;
            while (presenter.presentedViewController) presenter = presenter.presentedViewController;
            if (presenter) {
                if (activity.popoverPresentationController) {
                    activity.popoverPresentationController.sourceView = self.button;
                    activity.popoverPresentationController.sourceRect = self.button.bounds;
                }
                [presenter presentViewController:activity animated:YES completion:nil];
            }
        });
    });
}

@end

%ctor {
    @autoreleasepool {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(12 * NSEC_PER_SEC)),
                       dispatch_get_global_queue(QOS_CLASS_UTILITY, 0), ^{
            AMRunScan();
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)),
                       dispatch_get_main_queue(), ^{
            [[AMDiscoveryButton shared] install];
        });
    }
}
