#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <dlfcn.h>

// SmartMix is deliberately playback-neutral until the Taurus Beta source
// processor ABI, incoming PCM availability, and source-frame rejoin are
// verified on the target device. Never fake a two-track mix by fading the
// currently playing AudioUnit output.

static NSString *AMSymbolState(NSString *name) {
    return dlsym(RTLD_DEFAULT, name.UTF8String) ? @"present" : @"not exported";
}

static NSString *AMBuildReport(void) {
    NSBundle *bundle = NSBundle.mainBundle;
    NSMutableString *report = [NSMutableString stringWithFormat:
        @"Taurus SmartMix diagnostic\n"
         "Bundle: %@\nVersion: %@ (%@)\niOS: %@\nDevice: %@\n\n"
         "Playback safety: passthrough only; this build does not alter audio.\n"
         "Analysis: local SmartMix C++ core is linked into this dylib.\n"
         "Cloud analysis / substitute downloads: not used.\n\n",
        bundle.bundleIdentifier ?: @"unknown",
        bundle.infoDictionary[@"CFBundleShortVersionString"] ?: @"unknown",
        bundle.infoDictionary[@"CFBundleVersion"] ?: @"unknown",
        UIDevice.currentDevice.systemVersion,
        UIDevice.currentDevice.model];

    NSArray<NSString *> *symbols = @[
        @"SMAnalyzePCM", @"SMCreateStreamingAnalyzer", @"SMAppendPCM",
        @"SMAnalyzeLatest", @"SMPlanTransition", @"SMRenderEqualPower",
        @"SGAudioPipelineAvailable", @"SGAudioPipelineTapped",
        @"SGAudioPipelineSetSourceProcessor", @"SGAudioPipelinePull",
        @"SGAudioPipelinePullOriginal", @"SGAudioPipelineSourceFormat",
        @"SGAudioPipelineSourcePrefix", @"SGAudioPipelineSourceAheadFrames",
        @"SGAudioPipelineSourceCanReadAhead", @"SGAudioPipelineRegister"
    ];
    [report appendString:@"Runtime symbol visibility (presence is not proof of ABI):\n"];
    for (NSString *symbol in symbols) {
        [report appendFormat:@"%@: %@\n", symbol, AMSymbolState(symbol)];
    }
    [report appendString:
        @"\nNext gate: verify the Beta source callback signature, buffer lifetime, "
         "source identity, read-ahead meaning, frame clock, and exact rejoin on-device. "
         "AutoMix stays inactive until those checks pass."];
    return report;
}

@interface AutoMixStatusOverlay : NSObject
+ (instancetype)shared;
- (void)install;
@end

@implementation AutoMixStatusOverlay

+ (instancetype)shared {
    static AutoMixStatusOverlay *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [AutoMixStatusOverlay new];
    });
    return instance;
}

- (UIWindow *)activeWindow {
    for (UIScene *scene in UIApplication.sharedApplication.connectedScenes) {
        if (scene.activationState != UISceneActivationStateForegroundActive ||
            ![scene isKindOfClass:UIWindowScene.class]) continue;
        for (UIWindow *window in ((UIWindowScene *)scene).windows) {
            if (window.isKeyWindow) return window;
        }
    }
    return UIApplication.sharedApplication.windows.firstObject;
}

- (void)showStatus {
    UIWindow *window = [self activeWindow];
    UIViewController *controller = window.rootViewController;
    while (controller.presentedViewController) controller = controller.presentedViewController;
    if (!controller) return;

    NSString *report = AMBuildReport();
    UIAlertController *alert = [UIAlertController
        alertControllerWithTitle:@"SmartMix — Integration Pending"
        message:@"The local DSP core is loaded, but live mixing is intentionally disabled.\n\nTaurus Beta's next-track PCM and exact source-clock handoff must be verified first. Your music playback is left untouched."
        preferredStyle:UIAlertControllerStyleAlert];

    [alert addAction:[UIAlertAction actionWithTitle:@"Copy diagnostics"
        style:UIAlertActionStyleDefault handler:^(__unused UIAlertAction *action) {
            UIPasteboard.generalPasteboard.string = report;
        }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Close"
        style:UIAlertActionStyleCancel handler:nil]];
    [controller presentViewController:alert animated:YES completion:nil];
}

- (void)install {
    UIWindow *window = [self activeWindow];
    if (!window || [window viewWithTag:0x534D58]) return;

    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.tag = 0x534D58;
    button.frame = CGRectMake(MAX(12.0, window.bounds.size.width - 104.0), 150.0, 92.0, 42.0);
    button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
    button.backgroundColor = [UIColor colorWithWhite:0.12 alpha:0.94];
    button.layer.cornerRadius = 12.0;
    button.layer.borderWidth = 1.0;
    button.layer.borderColor = UIColor.systemTealColor.CGColor;
    [button setTitle:@"MIX STATUS" forState:UIControlStateNormal];
    [button setTitleColor:UIColor.systemTealColor forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:11.0];
    [button addTarget:self action:@selector(showStatus) forControlEvents:UIControlEventTouchUpInside];
    [window addSubview:button];
}

@end

__attribute__((constructor))
static void initAutoMixEngine(void) {
    // No AudioUnit hook is installed here. The only active behavior is a
    // small status overlay; audio remains byte-for-byte on Taurus's path.
    dispatch_async(dispatch_get_main_queue(), ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC),
                       dispatch_get_main_queue(), ^{
            [[AutoMixStatusOverlay shared] install];
        });
    });
}
