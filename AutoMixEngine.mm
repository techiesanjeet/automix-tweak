#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <Foundation/Foundation.h>
#import <dlfcn.h>

#include "smartmix/BeatThisCoreML.h"
#include "smartmix/BetaSourceProcessorProbe.h"

extern "C" void AMBetaAudioTapProbeInstall(void);
extern "C" NSString *AMBetaAudioTapProbeReport(void);
extern "C" void AMBetaPlaybackTimingProbeInstall(void);
extern "C" NSString *AMBetaPlaybackTimingProbeReport(void);
#include "smartmix/BeatThisSpectrogram.hpp"
#include "smartmix/BeatThisChunking.hpp"
#include <algorithm>
#include <chrono>
#include <cmath>
#include <vector>

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
         "Beat This: bundled Core ML adapter is available for local self-test.\n"
         "Cloud analysis / substitute downloads: not used.\n\n",
        bundle.bundleIdentifier ?: @"unknown",
        bundle.infoDictionary[@"CFBundleShortVersionString"] ?: @"unknown",
        bundle.infoDictionary[@"CFBundleVersion"] ?: @"unknown",
        UIDevice.currentDevice.systemVersion,
        UIDevice.currentDevice.model];

    NSArray<NSString *> *symbols = @[
        @"SMAnalyzePCM", @"SMCreateStreamingAnalyzer", @"SMAppendPCM",
        @"SMAnalyzeLatest", @"SMPlanTransition", @"SMRenderEqualPower",
        @"SMBeatThisPredictMonoChunk", @"SMBeatThisPredictMonoTrack",
        @"SMApplyBeatThisLogitsToTrack",
        @"SMBetaPipelineInspect",
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
    [report appendString:@"\n\nREAD-ONLY AUDIO TAP PROBE:\\n"];
    [report appendString:AMBetaAudioTapProbeReport() ?: @"Tap probe report unavailable.\\n"];
    [report appendString:@"\\nPLAYBACK TIMING PROBE:\\n"];
    [report appendString:AMBetaPlaybackTimingProbeReport() ?: @"Timing probe report unavailable.\\n"];
    [report appendString:
        @"\\nStatic disassembly has clarified the callback prototype, but Beta appears to "
         "have a single global processor slot. We do not replace it. The probes below are "
         "read-only and chain original callbacks. No PCM is dereferenced or changed. "
         "AutoMix stays inactive until incoming next-track PCM, source identity, frame clock, "
         "and exact rejoin are verified."]; 
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

- (void)runLocalModelSelfTestFrom:(UIViewController *)controller {
    __weak UIViewController *weakController = controller;
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        const auto started = std::chrono::steady_clock::now();
        SMBeatThisModel *model = SMBeatThisCreateInstalled();
        NSString *message = nil;
        if (!model) {
            message = @"The local Beat This Core ML bundle could not be loaded. "
                       "Check that SmartMixResources.bundle is installed beside the tweak resources.";
        } else {
            constexpr std::size_t audioFrames =
                60 * static_cast<std::size_t>(smartmix::kBeatThisSampleRate);
            const std::size_t modelFrames =
                smartmix::beatThisSpectrogramFrameCount(audioFrames);
            std::vector<smartmix::BeatThisChunkSpan> chunks;
            const bool chunkPlanReady =
                smartmix::makeBeatThisChunkPlan(modelFrames, chunks);
            std::vector<float> mono(audioFrames);
            std::vector<float> beat(modelFrames, 0.0f);
            std::vector<float> downbeat(modelFrames, 0.0f);
            for (std::size_t i = 0; i < mono.size(); ++i) {
                const double time = static_cast<double>(i) /
                    smartmix::kBeatThisSampleRate;
                mono[i] = static_cast<float>(0.15 * std::sin(
                    2.0 * 3.141592653589793 * 220.0 * time));
            }
            const int success = chunkPlanReady
                ? SMBeatThisPredictMonoTrack(
                    model, mono.data(), mono.size(), beat.data(),
                    downbeat.data(), modelFrames)
                : 0;
            const bool finiteOutput = success &&
                std::all_of(beat.begin(), beat.end(),
                    [](float value) { return std::isfinite(value); }) &&
                std::all_of(downbeat.begin(), downbeat.end(),
                    [](float value) { return std::isfinite(value); });
            SMBeatThisDestroy(model);
            const double elapsed = 1000.0 * std::chrono::duration<double>(
                std::chrono::steady_clock::now() - started).count();
            message = finiteOutput
                ? [NSString stringWithFormat:
                    @"Local model completed full-track chunked inference on a synthetic "
                     "60-second 220 Hz signal (%zu model windows, %zu frame logits).\n"
                     "Load + frontend + inference: %.1f ms.\n"
                     "No Taurus audio was read or changed.",
                    chunks.size(), modelFrames, elapsed]
                : @"The model loaded, but full-track chunked inference or finite-logit validation failed.";
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            UIViewController *presenter = weakController;
            if (!presenter) return;
            UIAlertController *result = [UIAlertController
                alertControllerWithTitle:@"Local Beat This self-test"
                message:message
                preferredStyle:UIAlertControllerStyleAlert];
            [result addAction:[UIAlertAction actionWithTitle:@"Close"
                style:UIAlertActionStyleCancel handler:nil]];
            [presenter presentViewController:result animated:YES completion:nil];
        });
    });
}

- (void)runBetaPipelineProbeFrom:(UIViewController *)controller {
    __weak UIViewController *weakController = controller;
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_UTILITY, 0), ^{
        SMBetaPipelineInfo info{};
        const int ok = SMBetaPipelineInspect(&info);
        NSString *message = nil;
        if (!ok) {
            message = @"The read-only Taurus pipeline probe could not run.";
        } else if (!info.sourceFormatAvailable) {
            message = [NSString stringWithFormat:
                @"Source format unavailable.\nResolved probe symbols: 0x%08x.\n"
                 "No processor was registered and no audio was pulled.", info.symbolMask];
        } else {
            const BOOL isFloat = (info.formatFlags & kAudioFormatFlagIsFloat) != 0;
            const BOOL nonInterleaved =
                (info.formatFlags & kAudioFormatFlagIsNonInterleaved) != 0;
            message = [NSString stringWithFormat:
                @"Source format: %.0f Hz, %u channels, %u-bit %@, %@.\n"
                 "Format ID: 0x%08x; flags: 0x%08x; bytes/frame: %u.\n"
                 "Read-ahead metadata available: %@. This does not prove next-track PCM.\n"
                 "Context-specific attached-query symbol available: %@. Actual slot owner is unknown.\n"
                 "No processor was registered, no audio was pulled, and playback was not changed.",
                info.sampleRate, info.channelsPerFrame, info.bitsPerChannel,
                isFloat ? @"float" : @"non-float",
                nonInterleaved ? @"non-interleaved" : @"interleaved",
                info.formatID, info.formatFlags, info.bytesPerFrame,
                info.canReadAhead ? @"yes" : @"no",
                info.processorAttachedQueryAvailable ? @"yes" : @"no"];
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            UIViewController *presenter = weakController;
            if (!presenter) return;
            UIAlertController *result = [UIAlertController
                alertControllerWithTitle:@"Taurus Beta source probe"
                message:message
                preferredStyle:UIAlertControllerStyleAlert];
            [result addAction:[UIAlertAction actionWithTitle:@"Close"
                style:UIAlertActionStyleCancel handler:nil]];
            [presenter presentViewController:result animated:YES completion:nil];
        });
    });
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
    [alert addAction:[UIAlertAction actionWithTitle:@"Test local model"
        style:UIAlertActionStyleDefault handler:^(__unused UIAlertAction *action) {
            [self runLocalModelSelfTestFrom:controller];
        }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Probe Taurus pipeline"
        style:UIAlertActionStyleDefault handler:^(__unused UIAlertAction *action) {
            [self runBetaPipelineProbeFrom:controller];
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
            AMBetaAudioTapProbeInstall();
            AMBetaPlaybackTimingProbeInstall();
            [[AutoMixStatusOverlay shared] install];
        });
    });
}
