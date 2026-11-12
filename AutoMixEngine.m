#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <stdint.h>
#import <math.h>
#import "fishhook.h"

// ==========================================
// 1. REAL-TIME AUDIO DSP ENGINE
// ==========================================

static OSStatus (*orig_AudioUnitRender)(
    AudioUnit                           inUnit,
    AudioUnitRenderActionFlags * __nullable ioActionFlags,
    const AudioTimeStamp *              inTimeStamp,
    UInt32                              inOutputBusNumber,
    UInt32                              inNumberFrames,
    AudioBufferList *                   ioData
);

// Shared state between UI thread and audio thread
static volatile bool  g_autoMixEnabled = true;
static volatile bool  g_isCrossfading = false;
static volatile bool  g_isPreviewMode = false;
static volatile float g_crossfadeProgress = 0.0f;
static volatile float g_fadeDurationSeconds = 4.0f;

static OSStatus custom_AudioUnitRender(
    AudioUnit                           inUnit,
    AudioUnitRenderActionFlags * __nullable ioActionFlags,
    const AudioTimeStamp *              inTimeStamp,
    UInt32                              inOutputBusNumber,
    UInt32                              inNumberFrames,
    AudioBufferList *                   ioData
) {
    OSStatus status = orig_AudioUnitRender(inUnit, ioActionFlags, inTimeStamp, inOutputBusNumber, inNumberFrames, ioData);

    if (status != noErr || ioData == NULL || !g_autoMixEnabled || !g_isCrossfading) {
        return status;
    }

    // Look up the stream format once per audio unit (cached)
    static AudioUnit s_unit = NULL;
    static bool      s_isFloat32 = true;
    static double    s_sampleRate = 44100.0;
    if (inUnit != s_unit) {
        AudioStreamBasicDescription asbd;
        UInt32 size = sizeof(asbd);
        if (AudioUnitGetProperty(inUnit, kAudioUnitProperty_StreamFormat,
                                 kAudioUnitScope_Output, inOutputBusNumber, &asbd, &size) == noErr) {
            s_isFloat32 = (asbd.mFormatFlags & kAudioFormatFlagIsFloat) && asbd.mBitsPerChannel == 32;
            if (asbd.mSampleRate > 0) s_sampleRate = asbd.mSampleRate;
        }
        s_unit = inUnit;
    }
    if (!s_isFloat32) return status; // don't corrupt non-float audio

    float progress = g_crossfadeProgress;
    float totalFrames = g_fadeDurationSeconds * (float)s_sampleRate;
    float step = (totalFrames > 0.0f) ? (1.0f / totalFrames) : 0.0001f;
    bool preview = g_isPreviewMode;

    for (UInt32 j = 0; j < inNumberFrames; j++) {
        float gain;
        if (preview) {
            // Dip to 15% and swell back to 100%
            float wave = cosf(progress * (float)M_PI * 2.0f);
            gain = 0.575f + (0.425f * wave);
        } else {
            // Equal-power fade out
            gain = cosf(progress * (float)M_PI_2);
        }

        for (UInt32 b = 0; b < ioData->mNumberBuffers; b++) {
            AudioBuffer buf = ioData->mBuffers[b];
            float *data = (float *)buf.mData;
            UInt32 channels = buf.mNumberChannels ? buf.mNumberChannels : 1;
            if (!data) continue;
            UInt32 framesInBuf = buf.mDataByteSize / (sizeof(float) * channels);
            if (j >= framesInBuf) continue;
            for (UInt32 c = 0; c < channels; c++) {
                data[j * channels + c] *= gain;
            }
        }

        progress += step;
        if (progress >= 1.0f) {
            progress = 0.0f;
            g_isCrossfading = false;
            g_isPreviewMode = false;
            break;
        }
    }

    g_crossfadeProgress = progress;
    return status;
}

// ==========================================
// 2. FLOATING SETTINGS MENU (UIKIT)
// ==========================================

@interface AutoMixOverlayManager : NSObject
@property (nonatomic, strong) UIButton *floatingButton;
@property (nonatomic, strong) UIView *menuCard;
@property (nonatomic, strong) UILabel *durationLabel;
@property (nonatomic, strong) UIButton *previewButton;
@property (nonatomic, assign) BOOL isMenuVisible;
+ (instancetype)sharedInstance;
- (void)setupOverlay;
@end

@implementation AutoMixOverlayManager

+ (instancetype)sharedInstance {
    static AutoMixOverlayManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[AutoMixOverlayManager alloc] init];
    });
    return instance;
}

- (UIWindow *)getActiveWindow {
    for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
        if (scene.activationState == UISceneActivationStateForegroundActive && [scene isKindOfClass:[UIWindowScene class]]) {
            UIWindowScene *windowScene = (UIWindowScene *)scene;
            for (UIWindow *window in windowScene.windows) {
                if (window.isKeyWindow) {
                    return window;
                }
            }
        }
    }
    return [UIApplication sharedApplication].windows.firstObject;
}

- (void)setupOverlay {
    UIWindow *keyWindow = [self getActiveWindow];
    if (!keyWindow) {
        // Window not ready yet, try again shortly
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self setupOverlay];
        });
        return;
    }
    if (self.floatingButton != nil) return;

    UIColor *green = [UIColor colorWithRed:0.11 green:0.73 blue:0.33 alpha:1.0];

    // Draggable floating button
    self.floatingButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.floatingButton.frame = CGRectMake(keyWindow.bounds.size.width - 65, 140, 48, 48);
    self.floatingButton.backgroundColor = [green colorWithAlphaComponent:0.95];
    [self.floatingButton setTitle:@"MIX" forState:UIControlStateNormal];
    [self.floatingButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.floatingButton.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    self.floatingButton.layer.cornerRadius = 24;
    self.floatingButton.layer.shadowColor = [UIColor blackColor].CGColor;
    self.floatingButton.layer.shadowOpacity = 0.4;
    self.floatingButton.layer.shadowOffset = CGSizeMake(0, 4);
    self.floatingButton.layer.shadowRadius = 6;
    [self.floatingButton addTarget:self action:@selector(toggleMenu) forControlEvents:UIControlEventTouchUpInside];

    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.floatingButton addGestureRecognizer:pan];
    [keyWindow addSubview:self.floatingButton];

    // Settings card (hidden initially)
    CGFloat cardWidth = 280;
    CGFloat cardHeight = 225;
    self.menuCard = [[UIView alloc] initWithFrame:CGRectMake((keyWindow.bounds.size.width - cardWidth) / 2.0,
                                                             (keyWindow.bounds.size.height - cardHeight) / 2.0,
                                                             cardWidth, cardHeight)];
    self.menuCard.backgroundColor = [UIColor colorWithWhite:0.10 alpha:0.96];
    self.menuCard.layer.cornerRadius = 18;
    self.menuCard.layer.borderWidth = 1.0;
    self.menuCard.layer.borderColor = [UIColor colorWithWhite:0.25 alpha:1.0].CGColor;
    self.menuCard.hidden = YES;

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, 16, 180, 24)];
    titleLabel.text = @"AutoMix DSP";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [self.menuCard addSubview:titleLabel];

    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    closeBtn.frame = CGRectMake(cardWidth - 44, 12, 32, 32);
    [closeBtn setTitle:@"✕" forState:UIControlStateNormal];
    [closeBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    closeBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [closeBtn addTarget:self action:@selector(toggleMenu) forControlEvents:UIControlEventTouchUpInside];
    [self.menuCard addSubview:closeBtn];

    UILabel *enableLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, 56, 160, 30)];
    enableLabel.text = @"Enable AutoMix";
    enableLabel.textColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    enableLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    [self.menuCard addSubview:enableLabel];

    UISwitch *enableSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(cardWidth - 68, 55, 51, 31)];
    enableSwitch.on = g_autoMixEnabled;
    enableSwitch.onTintColor = green;
    [enableSwitch addTarget:self action:@selector(onToggleSwitch:) forControlEvents:UIControlEventValueChanged];
    [self.menuCard addSubview:enableSwitch];

    self.durationLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, 98, cardWidth - 36, 22)];
    self.durationLabel.text = [NSString stringWithFormat:@"Transition Curve: %.1fs", g_fadeDurationSeconds];
    self.durationLabel.textColor = [UIColor lightGrayColor];
    self.durationLabel.font = [UIFont systemFontOfSize:13];
    [self.menuCard addSubview:self.durationLabel];

    UISlider *durationSlider = [[UISlider alloc] initWithFrame:CGRectMake(18, 122, cardWidth - 36, 30)];
    durationSlider.minimumValue = 1.0f;
    durationSlider.maximumValue = 10.0f;
    durationSlider.value = g_fadeDurationSeconds;
    durationSlider.minimumTrackTintColor = green;
    [durationSlider addTarget:self action:@selector(onSliderChanged:) forControlEvents:UIControlEventValueChanged];
    [self.menuCard addSubview:durationSlider];

    self.previewButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.previewButton.frame = CGRectMake(18, 165, cardWidth - 36, 42);
    self.previewButton.backgroundColor = green;
    [self.previewButton setTitle:@"Test Transition on Playing Song" forState:UIControlStateNormal];
    [self.previewButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.previewButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    self.previewButton.layer.cornerRadius = 10;
    [self.previewButton addTarget:self action:@selector(onPreviewTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.menuCard addSubview:self.previewButton];

    [keyWindow addSubview:self.menuCard];
}

- (void)handlePan:(UIPanGestureRecognizer *)gesture {
    UIView *superview = self.floatingButton.superview;
    CGPoint translation = [gesture translationInView:superview];
    CGPoint newCenter = CGPointMake(self.floatingButton.center.x + translation.x,
                                    self.floatingButton.center.y + translation.y);

    CGFloat halfW = self.floatingButton.bounds.size.width / 2.0;
    CGFloat halfH = self.floatingButton.bounds.size.height / 2.0;
    newCenter.x = MAX(halfW + 8, MIN(superview.bounds.size.width - halfW - 8, newCenter.x));
    newCenter.y = MAX(halfH + 40, MIN(superview.bounds.size.height - halfH - 40, newCenter.y));

    self.floatingButton.center = newCenter;
    [gesture setTranslation:CGPointZero inView:superview];
}

- (void)toggleMenu {
    self.isMenuVisible = !self.isMenuVisible;
    self.menuCard.hidden = !self.isMenuVisible;
    if (self.isMenuVisible) {
        [self.menuCard.superview bringSubviewToFront:self.menuCard];
    }
}

- (void)onToggleSwitch:(UISwitch *)sender {
    g_autoMixEnabled = sender.isOn;
    if (!g_autoMixEnabled) {
        g_isCrossfading = false;
        g_isPreviewMode = false;
        g_crossfadeProgress = 0.0f;
    }
}

- (void)onSliderChanged:(UISlider *)sender {
    g_fadeDurationSeconds = sender.value;
    self.durationLabel.text = [NSString stringWithFormat:@"Transition Curve: %.1fs", g_fadeDurationSeconds];
}

- (void)onPreviewTapped {
    UIColor *green = [UIColor colorWithRed:0.11 green:0.73 blue:0.33 alpha:1.0];
    if (!g_autoMixEnabled) {
        self.previewButton.backgroundColor = [UIColor systemRedColor];
        [self.previewButton setTitle:@"Enable AutoMix First!" forState:UIControlStateNormal];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.previewButton.backgroundColor = green;
            [self.previewButton setTitle:@"Test Transition on Playing Song" forState:UIControlStateNormal];
        });
        return;
    }

    g_crossfadeProgress = 0.0f;
    g_isPreviewMode = true;
    g_isCrossfading = true;

    [self.previewButton setTitle:@"Previewing Curve..." forState:UIControlStateNormal];
    self.previewButton.alpha = 0.7;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(g_fadeDurationSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.previewButton setTitle:@"Test Transition on Playing Song" forState:UIControlStateNormal];
        self.previewButton.alpha = 1.0;
    });
}

@end

// ==========================================
// 3. DYLIB ENTRYPOINT
// ==========================================

__attribute__((constructor)) static void initAutoMixEngine() {
    struct rebinding renderRebinding;
    renderRebinding.name = "AudioUnitRender";
    renderRebinding.replacement = (void *)custom_AudioUnitRender;
    renderRebinding.replaced = (void **)&orig_AudioUnitRender;

    struct rebinding rebindings[] = { renderRebinding };
    rebind_symbols(rebindings, 1);

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[AutoMixOverlayManager sharedInstance] setupOverlay];
    });
}
