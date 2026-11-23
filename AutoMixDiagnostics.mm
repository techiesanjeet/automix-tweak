#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <dlfcn.h>
#import <stdarg.h>
#import <objc/runtime.h>

static NSMutableString *gLog;
static NSMutableArray *gObservers;
static NSMutableSet *gHookedMethods;

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
static IMP gOrigTapFactoryInit;
static IMP gOrigTapAudioTapGetter;
static IMP gOrigBetamaxEnableAudioTap;
static IMP gOrigPlayerSourceEnableAudioTap;
static IMP gOrigPlayerSourceSetShouldEnableAudioTap;
static IMP gOrigPlayerSourceShouldEnableAudioTap;
static IMP gOrigPlayerSourceUpdateAudioTapForPlayerItem;
static IMP gOrigPlayerSourceSetItemWaitingForAudioTap;
static IMP gOrigPlayerSourcePlayerItem;
static IMP gOrigPlayerSourceLoadPlayerItem;
static IMP gOrigPlayerSourceCurrentItemChanged;
static IMP gOrigPlayerSourceDidChangeItemStatus;
static IMP gOrigPlayerSourceItemContainer;
static IMP gOrigPlayerSourcePlayer;
static IMP gOrigBetamaxPlayerSource;
static IMP gOrigPlayerSourceInit;
static IMP gOrigBetamaxSetPlayerSource;

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

// Trace the upstream opt-in gate. These selectors and scalar BOOL ABIs were
// confirmed from Taurus' Objective-C method encodings in the matching IPA.
static id AMHookTapFactoryInit(id self, SEL cmd, id delegate, id appState) {
    AMLog(@"BMAudioTapFactory init called factory=%p delegate=%p appState=%p", self, delegate, appState);
    id result = ((id (*)(id, SEL, id, id))gOrigTapFactoryInit)(self, cmd, delegate, appState);
    AMLog(@"BMAudioTapFactory init returned self=%p result=%p", self, result);
    return result;
}

static void *AMHookTapAudioTapGetter(id self, SEL cmd) {
    // This getter returns an opaque MTAudioProcessingTap pointer, not an Obj-C object.
    void *result = ((void *(*)(id, SEL))gOrigTapAudioTapGetter)(self, cmd);
    AMLog(@"BMAudioTap audioTap getter self=%p opaqueTap=%p", self, result);
    return result;
}

static void AMHookBetamaxEnableAudioTap(id self, SEL cmd, BOOL enabled) {
    AMLog(@"BMBetamaxPlayerImpl enableAudioTap self=%p enabled=%d", self, (int)enabled);
    ((void (*)(id, SEL, BOOL))gOrigBetamaxEnableAudioTap)(self, cmd, enabled);
}

static void AMHookPlayerSourceEnableAudioTap(id self, SEL cmd, BOOL enabled) {
    AMLog(@"BMPlayerSource enableAudioTap self=%p enabled=%d", self, (int)enabled);
    ((void (*)(id, SEL, BOOL))gOrigPlayerSourceEnableAudioTap)(self, cmd, enabled);
}

static void AMHookPlayerSourceSetShouldEnableAudioTap(id self, SEL cmd, BOOL enabled) {
    AMLog(@"BMPlayerSource setShouldEnableAudioTap self=%p enabled=%d", self, (int)enabled);
    ((void (*)(id, SEL, BOOL))gOrigPlayerSourceSetShouldEnableAudioTap)(self, cmd, enabled);
}

static BOOL AMHookPlayerSourceShouldEnableAudioTap(id self, SEL cmd) {
    BOOL enabled = ((BOOL (*)(id, SEL))gOrigPlayerSourceShouldEnableAudioTap)(self, cmd);
    AMLog(@"BMPlayerSource shouldEnableAudioTap self=%p result=%d", self, (int)enabled);
    return enabled;
}

static void AMHookPlayerSourceUpdateAudioTapForPlayerItem(id self, SEL cmd, id item) {
    NSString *itemClass = item ? NSStringFromClass([item class]) : @"<nil>";
    NSString *statusText = @"<not AVPlayerItem>";
    if ([item isKindOfClass:AVPlayerItem.class]) {
        AVPlayerItemStatus status = ((AVPlayerItem *)item).status;
        statusText = [NSString stringWithFormat:@"%ld (%@)", (long)status,
            status == AVPlayerItemStatusUnknown ? @"unknown" :
            status == AVPlayerItemStatusReadyToPlay ? @"readyToPlay" :
            status == AVPlayerItemStatusFailed ? @"failed" : @"other"];
    }
    AMLog(@"BMPlayerSource updateAudioTapForPlayerItem self=%p item=%p class=%@ status=%@",
          self, item, itemClass, statusText);
    ((void (*)(id, SEL, id))gOrigPlayerSourceUpdateAudioTapForPlayerItem)(self, cmd, item);
}

static void AMHookPlayerSourceSetItemWaitingForAudioTap(id self, SEL cmd, id item) {
    AMLog(@"BMPlayerSource setItemWaitingForAudioTap self=%p item=%p class=%@",
          self, item, item ? NSStringFromClass([item class]) : @"<nil>");
    ((void (*)(id, SEL, id))gOrigPlayerSourceSetItemWaitingForAudioTap)(self, cmd, item);
}

static id AMHookPlayerSourcePlayerItem(id self, SEL cmd) {
    id item = ((id (*)(id, SEL))gOrigPlayerSourcePlayerItem)(self, cmd);
    NSString *status = @"<not AVPlayerItem>";
    if ([item isKindOfClass:AVPlayerItem.class])
        status = [NSString stringWithFormat:@"%ld", (long)((AVPlayerItem *)item).status];
    AMLog(@"BMPlayerSource playerItem getter self=%p item=%p class=%@ status=%@",
          self, item, item ? NSStringFromClass([item class]) : @"<nil>", status);
    return item;
}

static void AMHookPlayerSourceLoadPlayerItem(id self, SEL cmd) {
    AMLog(@"BMPlayerSource loadPlayerItem entered self=%p", self);
    ((void (*)(id, SEL))gOrigPlayerSourceLoadPlayerItem)(self, cmd);
    AMLog(@"BMPlayerSource loadPlayerItem returned self=%p", self);
}

static void AMHookPlayerSourceCurrentItemChanged(id self, SEL cmd, id first, id second) {
    AMLog(@"BMPlayerSource currentPlayerItemChanged self=%p first=%p firstClass=%@ second=%p secondClass=%@",
          self, first, first ? NSStringFromClass([first class]) : @"<nil>",
          second, second ? NSStringFromClass([second class]) : @"<nil>");
    ((void (*)(id, SEL, id, id))gOrigPlayerSourceCurrentItemChanged)(self, cmd, first, second);
}

static void AMHookPlayerSourceDidChangeItemStatus(id self, SEL cmd, id first, id second) {
    AMLog(@"BMPlayerSource didChangePlayerItemStatus self=%p first=%p firstClass=%@ second=%p secondClass=%@",
          self, first, first ? NSStringFromClass([first class]) : @"<nil>",
          second, second ? NSStringFromClass([second class]) : @"<nil>");
    ((void (*)(id, SEL, id, id))gOrigPlayerSourceDidChangeItemStatus)(self, cmd, first, second);
}

static id AMHookPlayerSourceItemContainer(id self, SEL cmd) {
    id value = ((id (*)(id, SEL))gOrigPlayerSourceItemContainer)(self, cmd);
    AMLog(@"BMPlayerSource itemContainer getter self=%p value=%p class=%@",
          self, value, value ? NSStringFromClass([value class]) : @"<nil>");
    return value;
}

static id AMHookPlayerSourcePlayer(id self, SEL cmd) {
    id value = ((id (*)(id, SEL))gOrigPlayerSourcePlayer)(self, cmd);
    AMLog(@"BMPlayerSource player getter self=%p value=%p class=%@",
          self, value, value ? NSStringFromClass([value class]) : @"<nil>");
    return value;
}

static id AMHookBetamaxPlayerSource(id self, SEL cmd) {
    id value = ((id (*)(id, SEL))gOrigBetamaxPlayerSource)(self, cmd);
    AMLog(@"BMBetamaxPlayerImpl playerSource getter self=%p value=%p class=%@",
          self, value, value ? NSStringFromClass([value class]) : @"<nil>");
    return value;
}

// Construction/attachment probes establish whether this class is the live
// playback source. Runtime encoding confirms nine object arguments.
static id AMHookPlayerSourceInit(id self, SEL cmd, id configuration,
    id itemContainerFactory, id avFactory, id kvoControllerFactory,
    id playerItemObservableFactory, id playerTrackSelectorFactory,
    id metadataTypesProvider, id audioTapFactory, id notificationCenter) {
    AMLog(@"BMPlayerSource init entered self=%p config=%p containerFactory=%p avFactory=%p kvoFactory=%p itemObservableFactory=%p trackSelectorFactory=%p metadataProvider=%p audioTapFactory=%p notificationCenter=%p",
          self, configuration, itemContainerFactory, avFactory, kvoControllerFactory,
          playerItemObservableFactory, playerTrackSelectorFactory, metadataTypesProvider,
          audioTapFactory, notificationCenter);
    id result = ((id (*)(id, SEL, id, id, id, id, id, id, id, id, id))gOrigPlayerSourceInit)(
        self, cmd, configuration, itemContainerFactory, avFactory, kvoControllerFactory,
        playerItemObservableFactory, playerTrackSelectorFactory, metadataTypesProvider,
        audioTapFactory, notificationCenter);
    AMLog(@"BMPlayerSource init returned self=%p result=%p class=%@", self, result,
          result ? NSStringFromClass([result class]) : @"<nil>");
    return result;
}

static void AMHookBetamaxSetPlayerSource(id self, SEL cmd, id source) {
    AMLog(@"BMBetamaxPlayerImpl setPlayerSource entered player=%p source=%p class=%@",
          self, source, source ? NSStringFromClass([source class]) : @"<nil>");
    ((void (*)(id, SEL, id))gOrigBetamaxSetPlayerSource)(self, cmd, source);
    AMLog(@"BMBetamaxPlayerImpl setPlayerSource returned player=%p", self);
}

static BOOL AMHookInstanceMethod(Class cls, SEL selector, IMP replacement, IMP *original) {
    if (!cls) return NO;
    NSString *hookKey = [NSString stringWithFormat:@"%p:%@", cls, NSStringFromSelector(selector)];
    @synchronized (gHookedMethods) {
        if ([gHookedMethods containsObject:hookKey]) return YES;
    }
    Method method = class_getInstanceMethod(cls, selector);
    if (!method) {
        AMLog(@"audio-tap hook unavailable class=%@ selector=%@", NSStringFromClass(cls), NSStringFromSelector(selector));
        return NO;
    }
    *original = method_setImplementation(method, replacement);
    AMLog(@"audio-tap hook installed class=%@ selector=%@ original=%p replacement=%p",
          NSStringFromClass(cls), NSStringFromSelector(selector), *original, replacement);
    if (*original) {
        @synchronized (gHookedMethods) { [gHookedMethods addObject:hookKey]; }
    }
    return *original != NULL;
}

// Dump the concrete player-source object surface before selecting further hooks.
// This is metadata-only: it does not invoke any private method or mutate playback.
static void AMDumpClassSurface(Class cls) {
    for (Class current = cls; current && current != NSObject.class; current = class_getSuperclass(current)) {
        AMLog(@"runtime surface class=%@ superclass=%@", NSStringFromClass(current),
              class_getSuperclass(current) ? NSStringFromClass(class_getSuperclass(current)) : @"<nil>");
        unsigned methodCount = 0;
        Method *methods = class_copyMethodList(current, &methodCount);
        for (unsigned i = 0; i < methodCount; i++) {
            SEL selector = method_getName(methods[i]);
            NSString *name = NSStringFromSelector(selector);
            NSString *lower = name.lowercaseString;
            if ([lower containsString:@"item"] || [lower containsString:@"player"] ||
                [lower containsString:@"source"] || [lower containsString:@"tap"] ||
                [lower containsString:@"audio"]) {
                char *types = method_copyReturnType(methods[i]);
                AMLog(@"runtime method %@ %@ return=%s types=%s imp=%p", NSStringFromClass(current),
                      name, types ?: "?", method_getTypeEncoding(methods[i]) ?: "?", method_getImplementation(methods[i]));
                free(types);
            }
        }
        free(methods);

        unsigned propertyCount = 0;
        objc_property_t *properties = class_copyPropertyList(current, &propertyCount);
        for (unsigned i = 0; i < propertyCount; i++) {
            const char *name = property_getName(properties[i]);
            const char *attrs = property_getAttributes(properties[i]);
            NSString *lower = name ? [@(name) lowercaseString] : @"";
            if ([lower containsString:@"item"] || [lower containsString:@"player"] ||
                [lower containsString:@"source"] || [lower containsString:@"tap"] ||
                [lower containsString:@"audio"])
                AMLog(@"runtime property %@ %s attrs=%s", NSStringFromClass(current),
                      name ?: "?", attrs ?: "?");
        }
        free(properties);

        unsigned ivarCount = 0;
        Ivar *ivars = class_copyIvarList(current, &ivarCount);
        for (unsigned i = 0; i < ivarCount; i++) {
            const char *name = ivar_getName(ivars[i]);
            const char *type = ivar_getTypeEncoding(ivars[i]);
            NSString *lower = name ? [@(name) lowercaseString] : @"";
            if ([lower containsString:@"item"] || [lower containsString:@"player"] ||
                [lower containsString:@"source"] || [lower containsString:@"tap"] ||
                [lower containsString:@"audio"])
                AMLog(@"runtime ivar %@ %s type=%s offset=%td", NSStringFromClass(current),
                      name ?: "?", type ?: "?", ivar_getOffset(ivars[i]));
        }
        free(ivars);
    }
}

static void AMInstallAudioTapHooks(void) {
    Class factory = objc_getClass("BMAudioTapFactory");
    Class tap = objc_getClass("BMAudioTap");
    Class multiTap = objc_getClass("_TtC22MultiPlayer_PlayerImpl19MultiPlayerAudioTap");
    AMLog(@"audio-tap classes factory=%p tap=%p multiTap=%p", factory, tap, multiTap);

    AMHookInstanceMethod(factory, @selector(createAudioTapWithPlayerItem:completion:),
                         (IMP)AMHookTapFactoryCreate, &gOrigTapFactoryCreate);
    AMHookInstanceMethod(factory, @selector(initWithAudioTapDelegate:appStateObservable:),
                         (IMP)AMHookTapFactoryInit, &gOrigTapFactoryInit);
    AMHookInstanceMethod(tap, @selector(audioTap),
                         (IMP)AMHookTapAudioTapGetter, &gOrigTapAudioTapGetter);

    Class betamax = objc_getClass("BMBetamaxPlayerImpl");
    Class playerSource = objc_getClass("BMPlayerSource");
    AMLog(@"audio-tap upstream classes betamax=%p playerSource=%p", betamax, playerSource);
    AMDumpClassSurface(playerSource);
    AMDumpClassSurface(betamax);
    AMHookInstanceMethod(betamax, @selector(enableAudioTap:),
                         (IMP)AMHookBetamaxEnableAudioTap, &gOrigBetamaxEnableAudioTap);
    AMHookInstanceMethod(playerSource, @selector(enableAudioTap:),
                         (IMP)AMHookPlayerSourceEnableAudioTap, &gOrigPlayerSourceEnableAudioTap);
    AMHookInstanceMethod(playerSource, @selector(setShouldEnableAudioTap:),
                         (IMP)AMHookPlayerSourceSetShouldEnableAudioTap, &gOrigPlayerSourceSetShouldEnableAudioTap);
    AMHookInstanceMethod(playerSource, @selector(shouldEnableAudioTap),
                         (IMP)AMHookPlayerSourceShouldEnableAudioTap, &gOrigPlayerSourceShouldEnableAudioTap);
    AMHookInstanceMethod(playerSource, @selector(updateAudioTapForPlayerItem:),
                         (IMP)AMHookPlayerSourceUpdateAudioTapForPlayerItem, &gOrigPlayerSourceUpdateAudioTapForPlayerItem);
    AMHookInstanceMethod(playerSource, @selector(setItemWaitingForAudioTap:),
                         (IMP)AMHookPlayerSourceSetItemWaitingForAudioTap, &gOrigPlayerSourceSetItemWaitingForAudioTap);
    AMHookInstanceMethod(playerSource, @selector(playerItem),
                         (IMP)AMHookPlayerSourcePlayerItem, &gOrigPlayerSourcePlayerItem);
    AMHookInstanceMethod(playerSource, @selector(loadPlayerItem),
                         (IMP)AMHookPlayerSourceLoadPlayerItem, &gOrigPlayerSourceLoadPlayerItem);
    AMHookInstanceMethod(playerSource, @selector(currentPlayerItemChanged:object:),
                         (IMP)AMHookPlayerSourceCurrentItemChanged, &gOrigPlayerSourceCurrentItemChanged);
    AMHookInstanceMethod(playerSource, @selector(didChangePlayerItemStatus:playerItem:),
                         (IMP)AMHookPlayerSourceDidChangeItemStatus, &gOrigPlayerSourceDidChangeItemStatus);
    AMHookInstanceMethod(playerSource, @selector(itemContainer),
                         (IMP)AMHookPlayerSourceItemContainer, &gOrigPlayerSourceItemContainer);
    AMHookInstanceMethod(playerSource, @selector(player),
                         (IMP)AMHookPlayerSourcePlayer, &gOrigPlayerSourcePlayer);
    AMHookInstanceMethod(betamax, @selector(playerSource),
                         (IMP)AMHookBetamaxPlayerSource, &gOrigBetamaxPlayerSource);
    AMHookInstanceMethod(playerSource,
        @selector(initWithPlayerConfiguration:itemContainerFactory:avFactory:kvoControllerFactory:playerItemObservableFactory:playerTrackSelectorFactory:metadataTypesProvider:audioTapFactory:notificationCenter:),
        (IMP)AMHookPlayerSourceInit, &gOrigPlayerSourceInit);
    AMHookInstanceMethod(betamax, @selector(setPlayerSource:),
        (IMP)AMHookBetamaxSetPlayerSource, &gOrigBetamaxSetPlayerSource);
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
        gHookedMethods = [NSMutableSet new];
        AMLog(@"AutoMix diagnostics loaded; observation only; no private playback methods are called.");
        AMObserveNotification(@"SGAutoMixStatusDidChangeNotification");
        AMObserveNotification(@"SGPlayerTransitionNotification");
        AMObserveNotification(@"SGPlayerTransitionEndedNotification");
        AMObserveNotification(@"UIApplicationDidBecomeActiveNotification");
        AMCollectSnapshot(@"dylib load");
        // Install at dylib load to catch player-source construction; the
        // delayed pass retries any classes not registered yet.
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
