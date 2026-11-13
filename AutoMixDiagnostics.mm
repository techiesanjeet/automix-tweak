#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <dlfcn.h>
#import <objc/runtime.h>

static NSMutableString *gLog;
static NSMutableArray *gObservers;

static void AMLog(NSString *format, ...) {
    va_list args;
    va_start(args, format);
    NSString *line = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    @synchronized (gLog) {
        [gLog appendFormat:@"%@\n", line];
    }
    NSLog(@"[AutoMixDiagnostics] %@", line);
}

static NSString *AMPointer(const char *name) {
    void *p = dlsym(RTLD_DEFAULT, name);
    return p ? [NSString stringWithFormat:@"FOUND %p", p] : @"NOT FOUND";
}

static UIWindow *AMKeyWindow(void) {
    for (UIScene *scene in UIApplication.sharedApplication.connectedScenes) {
        if (scene.activationState != UISceneActivationStateForegroundActive ||
            ![scene isKindOfClass:UIWindowScene.class]) continue;
        for (UIWindow *window in ((UIWindowScene *)scene).windows) {
            if (window.isKeyWindow) return window;
        }
    }
    return UIApplication.sharedApplication.windows.firstObject;
}

static void AMShowLog(void) {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *window = AMKeyWindow();
        UIViewController *root = window.rootViewController;
        while (root.presentedViewController) root = root.presentedViewController;
        if (!root) return;

        NSString *snapshot;
        @synchronized (gLog) { snapshot = [gLog copy]; }
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"AutoMix diagnostics"
            message:@"Copy this report and paste it into the chat. No playback controls are changed."
            preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"Copy report" style:UIAlertActionStyleDefault handler:^(__unused UIAlertAction *a) {
            UIPasteboard.generalPasteboard.string = snapshot ?: @"No diagnostics collected.";
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleCancel handler:nil]];
        [root presentViewController:alert animated:YES completion:nil];
    });
}

static void AMInstallButton(void) {
    UIWindow *window = AMKeyWindow();
    if (!window || [window viewWithTag:0xA170]) return;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.tag = 0xA170;
    button.frame = CGRectMake(MAX(12, window.bounds.size.width - 72), 190, 58, 42);
    button.backgroundColor = [UIColor colorWithWhite:0.12 alpha:0.94];
    button.layer.cornerRadius = 12;
    button.layer.borderWidth = 1;
    button.layer.borderColor = UIColor.systemTealColor.CGColor;
    [button setTitle:@"LOG" forState:UIControlStateNormal];
    [button setTitleColor:UIColor.systemTealColor forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    [button addTarget:[NSBlockOperation blockOperationWithBlock:^{ AMShowLog(); }]
               action:@selector(main) forControlEvents:UIControlEventTouchUpInside];
    // Use a retained target object so UIKit can deliver the tap.
    [button removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
    [button addTarget:window.rootViewController action:@selector(am_showAutoMixDiagnosticLog)
       forControlEvents:UIControlEventTouchUpInside];
    [window addSubview:button];
}

// A small controller category gives the LOG button a stable action target.
@interface UIViewController (AMDiagnostics)
- (void)am_showAutoMixDiagnosticLog;
@end
@implementation UIViewController (AMDiagnostics)
- (void)am_showAutoMixDiagnosticLog { AMShowLog(); }
@end

static void AMCollectSnapshot(NSString *reason) {
    AMLog(@"--- snapshot: %@ ---", reason);
    NSBundle *bundle = NSBundle.mainBundle;
    AMLog(@"bundle=%@ version=%@ build=%@", bundle.bundleIdentifier,
          bundle.infoDictionary[@"CFBundleShortVersionString"],
          bundle.infoDictionary[@"CFBundleVersion"]);

    NSArray *symbols = @[
        @"SGAutoMixSupportedVersion", @"SGAutoMixEnabled",
        @"SGAutoMixUsesBeatMatching", @"SGAutoMixBlendSeconds",
        @"SGAutoMixPlayerAvailable", @"SGAutoMixApplyCurrentPlayback",
        @"SGAutoMixPlayerStateChanged", @"SGAutoMixSettingsChanged",
        @"SGAutoMixStatus", @"SGAutoMixLastTransition",
        @"SGAutoMixHasTransition", @"SGAutoMixConfiguration"
    ];
    for (NSString *symbol in symbols)
        AMLog(@"symbol %@: %@", symbol, AMPointer(symbol.UTF8String));

    NSArray *keys = @[
        @"spotifyglass.automix", @"spotifyglass.automix.savedPreferences",
        @"spotifyglass.automix.style", @"spotifyglass.automix.length",
        @"audioAutomix", @"audioCrossfade", @"audioCrossfadeTime"
    ];
    NSUserDefaults *defaults = NSUserDefaults.standardUserDefaults;
    for (NSString *key in keys) {
        id value = [defaults objectForKey:key];
        AMLog(@"defaults[%@]=%@", key, value ? [value description] : @"<unset>");
    }

    AVAudioSession *session = AVAudioSession.sharedInstance;
    AMLog(@"audioSession category=%@ mode=%@ sampleRate=%.1f outputLatency=%.4f",
          session.category, session.mode, session.sampleRate, session.outputLatency);
    for (AVAudioSessionPortDescription *port in session.currentRoute.outputs)
        AMLog(@"audioOutput=%@ type=%@", port.portName, port.portType);
}

static void AMObserveNotification(NSString *name) {
    id token = [NSNotificationCenter.defaultCenter
        addObserverForName:name object:nil queue:NSOperationQueue.mainQueue
        usingBlock:^(NSNotification *note) {
            AMLog(@"notification=%@ object=%@ userInfo=%@", name,
                  note.object ?: @"<nil>", note.userInfo ?: @{});
        }];
    if (token) [gObservers addObject:token];
}

__attribute__((constructor))
static void AMDiagnosticsInit(void) {
    @autoreleasepool {
        gLog = [NSMutableString new];
        gObservers = [NSMutableArray new];
        AMLog(@"AutoMix diagnostics loaded; observation only; no private playback methods are called.");
        AMObserveNotification(@"SGAutoMixStatusDidChangeNotification");
        AMObserveNotification(@"SGPlayerTransitionNotification");
        AMObserveNotification(@"SGPlayerTransitionEndedNotification");
        AMObserveNotification(@"UIApplicationDidBecomeActiveNotification");
        AMCollectSnapshot(@"dylib load");

        dispatch_async(dispatch_get_main_queue(), ^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                AMInstallButton();
                AMCollectSnapshot(@"3 seconds after launch");
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 30 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                AMCollectSnapshot(@"30 seconds after launch");
            });
        });
    }
}
