#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <mach-o/dyld.h>

static BOOL AMContainsAny(NSString *value, NSArray<NSString *> *needles) {
    NSString *lower = value.lowercaseString;
    for (NSString *needle in needles) if ([lower containsString:needle]) return YES;
    return NO;
}

static NSString *AMRunPlaybackSurfaceScan(void) {
    @autoreleasepool {
        NSMutableString *report = [NSMutableString string];
        NSBundle *bundle = NSBundle.mainBundle;
        [report appendString:@"AutoMix playback-surface diagnostic\n"];
        [report appendFormat:@"Bundle: %@\n", bundle.bundleIdentifier ?: @"unknown"];
        [report appendFormat:@"Version: %@ (%@)\n\n",
            [bundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"] ?: @"unknown",
            [bundle objectForInfoDictionaryKey:@"CFBundleVersion"] ?: @"unknown"];

        NSArray<NSString *> *classNeedles = @[@"spotify", @"audio", @"player", @"playback", @"queue",
            @"track", @"decoder", @"stream", @"mixer", @"avplayer", @"crossfade", @"automix", @"render", @"media"];
        NSArray<NSString *> *methodNeedles = @[@"play", @"audio", @"queue", @"track", @"decode", "render",
            @"stream", @"crossfade", @"automix", @"seek", @"load", @"prepare", @"engine", @"player", @"source", @"output"];

        int classCount = objc_getClassList(NULL, 0);
        if (classCount < 1) {
            [report appendString:@"Objective-C runtime returned no classes.\n"];
        } else {
            Class *classes = (Class *)calloc((size_t)classCount, sizeof(Class));
            int actualCount = objc_getClassList(classes, classCount);
            [report appendFormat:@"Loaded Objective-C classes: %d\n", actualCount];
            NSUInteger emittedClasses = 0;
            for (int i = 0; i < actualCount && emittedClasses < 350; i++) {
                const char *rawName = class_getName(classes[i]);
                if (!rawName) continue;
                NSString *className = [NSString stringWithUTF8String:rawName];
                if (!AMContainsAny(className, classNeedles)) continue;
                [report appendFormat:@"\n[%@]\n", className];
                emittedClasses++;

                unsigned int methodCount = 0;
                Method *methods = class_copyMethodList(classes[i], &methodCount);
                NSUInteger emittedMethods = 0;
                for (unsigned int m = 0; m < methodCount && emittedMethods < 35; m++) {
                    const char *rawSelector = sel_getName(method_getName(methods[m]));
                    if (!rawSelector) continue;
                    NSString *selectorName = [NSString stringWithUTF8String:rawSelector];
                    if (AMContainsAny(selectorName, methodNeedles)) {
                        [report appendFormat:@"  - %@\n", selectorName];
                        emittedMethods++;
                    }
                }
                free(methods);

                Class meta = object_getClass(classes[i]);
                unsigned int classMethodCount = 0;
                Method *classMethods = class_copyMethodList(meta, &classMethodCount);
                NSUInteger emittedClassMethods = 0;
                for (unsigned int m = 0; m < classMethodCount && emittedClassMethods < 20; m++) {
                    const char *rawSelector = sel_getName(method_getName(classMethods[m]));
                    if (!rawSelector) continue;
                    NSString *selectorName = [NSString stringWithUTF8String:rawSelector];
                    if (AMContainsAny(selectorName, methodNeedles)) {
                        [report appendFormat:@"  + %@\n", selectorName];
                        emittedClassMethods++;
                    }
                }
                free(classMethods);
            }
            free(classes);
            [report appendFormat:@"\nMatched classes: %lu (output capped at 350)\n", (unsigned long)emittedClasses];
        }

        [report appendString:@"\nRelevant loaded images/frameworks:\n"];
        uint32_t imageCount = _dyld_image_count();
        NSUInteger emittedImages = 0;
        for (uint32_t i = 0; i < imageCount && emittedImages < 120; i++) {
            const char *rawPath = _dyld_get_image_name(i);
            if (!rawPath) continue;
            NSString *path = [NSString stringWithUTF8String:rawPath];
            if (AMContainsAny(path, @[@"spotify", @"audio", @"avfaudio", @"coreaudio", @"media", @"playback", @"music"])) {
                [report appendFormat:@"  %@\n", path];
                emittedImages++;
            }
        }
        [report appendFormat:@"\nMatched images: %lu\n", (unsigned long)emittedImages];
        [report appendString:@"\nLimitations: lists loaded runtime class/method metadata and images only. It does not read, extract, decode, or copy protected audio. A matching class name does not prove a usable independent playback deck exists.\n"];
        return report;
    }
}

@interface AMProbeOverlay : NSObject
@property(nonatomic, strong) UIButton *button;
+ (instancetype)shared;
- (void)install;
- (void)scanAndCopy;
@end

@implementation AMProbeOverlay
+ (instancetype)shared {
    static AMProbeOverlay *instance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{ instance = [AMProbeOverlay new]; });
    return instance;
}
- (UIWindow *)activeWindow {
    if (@available(iOS 13.0, *)) {
        for (UIScene *scene in UIApplication.sharedApplication.connectedScenes) {
            if (scene.activationState != UISceneActivationStateForegroundActive || ![scene isKindOfClass:UIWindowScene.class]) continue;
            for (UIWindow *window in ((UIWindowScene *)scene).windows) if (window.isKeyWindow) return window;
        }
    }
    return UIApplication.sharedApplication.windows.firstObject;
}
- (void)install {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *window = [self activeWindow];
        if (!window) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ [self install]; });
            return;
        }
        if (self.button) return;
        self.button = [UIButton buttonWithType:UIButtonTypeSystem];
        self.button.frame = CGRectMake(MAX(12, window.bounds.size.width - 112), 150, 100, 42);
        self.button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
        self.button.backgroundColor = [UIColor colorWithRed:0.12 green:0.72 blue:0.34 alpha:0.96];
        [self.button setTitle:@"AM SCAN" forState:UIControlStateNormal];
        [self.button setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        self.button.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        self.button.layer.cornerRadius = 12;
        self.button.layer.shadowOpacity = 0.25;
        self.button.layer.shadowRadius = 5;
        [self.button addTarget:self action:@selector(scanAndCopy) forControlEvents:UIControlEventTouchUpInside];
        [window addSubview:self.button];
    });
}
- (void)scanAndCopy {
    NSString *report = AMRunPlaybackSurfaceScan();
    UIPasteboard.generalPasteboard.string = report;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"AutoMix diagnostic copied"
        message:@"The playback-surface report is on your clipboard. Paste it into this chat so I can inspect the results."
        preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    UIViewController *presenter = self.button.window.rootViewController;
    while (presenter.presentedViewController) presenter = presenter.presentedViewController;
    [presenter presentViewController:alert animated:YES completion:nil];
}
@end

__attribute__((constructor))
static void AMProbeInit(void) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[AMProbeOverlay shared] install];
    });
}
