#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <dlfcn.h>
#import <stdarg.h>
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


// Passive probes for Taurus' BMAudioTap route. We only observe lifecycle and
// buffer descriptors; we never retain, modify, or replace the host audio data.
#include <stdatomic.h>
#include <stdint.h>

typedef struct {
    float *unusedBuffer;
    float *bufferA;
    uint64_t framesA;
    float *bufferB;
    uint64_t framesB;
    float *bufferC;
    uint64_t framesC;
    uint64_t trailingValue;
} AMBMAudioTapOutput;

static IMP gOrigTapFactoryCreate;
static IMP gOrigTapInit;
static IMP gOrigTapIsEnabled;
static IMP gOrigTapStop;
static IMP gOrigMultiTapOutput;
static atomic_uint gTapOutputEvents = 0;

static void AMHookTapFactoryCreate(id self, SEL cmd, id playerItem, id completion) {
    AMLog(@"BMAudioTapFactory createAudioTapWithPlayerItem called factory=%p item=%p itemClass=%@ completion=%p",
          self, playerItem, playerItem ? NSStringFromClass([playerItem class]) : @"<nil>", completion);
    ((void (*)(id, SEL, id, id))gOrigTapFactoryCreate)(self, cmd, playerItem, completion);
}

static id AMHookTapInit(id self, SEL cmd, id playerItem, id appState, id delegate) {
    AMLog(@"BMAudioTap init entered self=%p item=%p itemClass=%@ appState=%p delegate=%p",
          self, playerItem, playerItem ? NSStringFromClass([playerItem class]) : @"<nil>", appState, delegate);
    id result = ((id (*)(id, SEL, id, id, id))gOrigTapInit)(self, cmd, playerItem, appState, delegate);
    AMLog(@"BMAudioTap init returned self=%p result=%p", self, result);
    return result;
}

static BOOL AMHookTapIsEnabled(id self, SEL cmd) {
    BOOL enabled = ((BOOL (*)(id, SEL))gOrigTapIsEnabled)(self, cmd);
    AMLog(@"BMAudioTap isEnabled self=%p result=%d", self, (int)enabled);
    return enabled;
}

static void AMHookTapStop(id self, SEL cmd) {
    AMLog(@"BMAudioTap stopProcessing self=%p", self);
    ((void (*)(id, SEL))gOrigTapStop)(self, cmd);
}

static void AMHookMultiTapOutput(id self, SEL cmd, const AMBMAudioTapOutput *output) {
    unsigned event = atomic_fetch_add_explicit(&gTapOutputEvents, 1, memory_order_relaxed) + 1;
    if (event <= 12) {
        // The three counted Float32 arrays are described by pointer/count pairs.
        // Do not read sample memory here: callback timing and ownership are private.
        uintptr_t a = output ? (uintptr_t)output->bufferA : 0;
        uintptr_t b = output ? (uintptr_t)output->bufferB : 0;
        uintptr_t c = output ? (uintptr_t)output->bufferC : 0;
        uint64_t na = output ? output->framesA : 0;
        uint64_t nb = output ? output->framesB : 0;
        uint64_t nc = output ? output->framesC : 0;
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_UTILITY, 0), ^{
            AMLog(@"MultiPlayerAudioTap output #%u self=%p descriptor=%p A=%p/%llu B=%p/%llu C=%p/%llu",
                  event, self, output, (void *)a, na, (void *)b, nb, (void *)c, nc);
        });
    }
    ((void (*)(id, SEL, const AMBMAudioTapOutput *))gOrigMultiTapOutput)(self, cmd, output);
}

static BOOL AMHookInstanceMethod(Class cls, SEL selector, IMP replacement, IMP *original) {
    if (!cls) return NO;
    Method method = class_getInstanceMethod(cls, selector);
    if (!method) {
        AMLog(@"audio-tap hook unavailable class=%@ selector=%@", NSStringFromClass(cls), NSStringFromSelector(selector));
        return NO;
    }
    *original = method_setImplementation(method, replacement);
    AMLog(@"audio-tap hook installed class=%@ selector=%@ original=%p replacement=%p",
          NSStringFromClass(cls), NSStringFromSelector(selector), *original, replacement);
    return *original != NULL;
}

static void AMInstallAudioTapHooks(void) {
    Class factory = objc_getClass("BMAudioTapFactory");
    Class tap = objc_getClass("BMAudioTap");
    Class multiTap = objc_getClass("_TtC22MultiPlayer_PlayerImpl19MultiPlayerAudioTap");
    AMLog(@"audio-tap classes factory=%p tap=%p multiTap=%p", factory, tap, multiTap);

    AMHookInstanceMethod(factory, @selector(createAudioTapWithPlayerItem:completion:),
                         (IMP)AMHookTapFactoryCreate, &gOrigTapFactoryCreate);
    AMHookInstanceMethod(tap, @selector(initWithPlayerItem:appStateObservable:delegate:),
                         (IMP)AMHookTapInit, &gOrigTapInit);
    AMHookInstanceMethod(tap, @selector(isEnabled), (IMP)AMHookTapIsEnabled, &gOrigTapIsEnabled);
    AMHookInstanceMethod(tap, @selector(stopProcessing), (IMP)AMHookTapStop, &gOrigTapStop);
    AMHookInstanceMethod(multiTap, @selector(audioTapDidEmitOutput:),
                         (IMP)AMHookMultiTapOutput, &gOrigMultiTapOutput);
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
        AMInstallAudioTapHooks();

        dispatch_async(dispatch_get_main_queue(), ^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                AMInstallButton();
                AMInstallAudioTapHooks();
                AMCollectSnapshot(@"3 seconds after launch");
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 30 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                AMCollectSnapshot(@"30 seconds after launch");
            });
        });
    }
}
