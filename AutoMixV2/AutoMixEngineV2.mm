#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <atomic>
#import <cmath>
#import <cstdint>
#import "fishhook.h"

// Standalone two-deck gain engine. A Spotify-specific adapter must register the
// actual outgoing and incoming AudioUnits before starting a transition.
namespace AMV2 {
enum DeckRole : int { Outgoing = 0, Incoming = 1 };
static std::atomic<AudioUnit> outgoingDeck{nullptr};
static std::atomic<AudioUnit> incomingDeck{nullptr};
static std::atomic<AudioUnit> &deckFor(int role) {
    return role == Incoming ? incomingDeck : outgoingDeck;
}
static std::atomic<bool> enabled{true};
static std::atomic<int> phase{0}; // 0 idle, 1 mixing, 2 completed
static std::atomic<uint64_t> elapsedFrames{0};
static std::atomic<uint64_t> totalFrames{0};
static std::atomic<uint32_t> sampleRate{44100};

static OSStatus (*originalRender)(AudioUnit, AudioUnitRenderActionFlags *,
    const AudioTimeStamp *, UInt32, UInt32, AudioBufferList *) = nullptr;

static bool isFloat32(AudioUnit unit, UInt32 bus) {
    AudioStreamBasicDescription asbd{};
    UInt32 size = sizeof(asbd);
    if (AudioUnitGetProperty(unit, kAudioUnitProperty_StreamFormat,
        kAudioUnitScope_Output, bus, &asbd, &size) != noErr) return false;
    return (asbd.mFormatFlags & kAudioFormatFlagIsFloat) &&
           asbd.mBitsPerChannel == 32 && asbd.mSampleRate > 0;
}

static void applyGain(AudioBufferList *list, UInt32 frames, float gain) {
    if (!list || !std::isfinite(gain)) return;
    gain = fmaxf(0.0f, fminf(1.0f, gain));
    for (UInt32 b = 0; b < list->mNumberBuffers; ++b) {
        AudioBuffer &buffer = list->mBuffers[b];
        if (!buffer.mData) continue;
        const UInt32 channels = buffer.mNumberChannels ? buffer.mNumberChannels : 1;
        const UInt32 available = buffer.mDataByteSize / (sizeof(float) * channels);
        const UInt32 count = (frames < available) ? frames : available;
        float *samples = static_cast<float *>(buffer.mData);
        for (UInt32 f = 0; f < count; ++f)
            for (UInt32 c = 0; c < channels; ++c)
                samples[f * channels + c] *= gain;
    }
}

static OSStatus hookedRender(AudioUnit unit, AudioUnitRenderActionFlags *flags,
    const AudioTimeStamp *time, UInt32 bus, UInt32 frames, AudioBufferList *data) {
    OSStatus result = originalRender
        ? originalRender(unit, flags, time, bus, frames, data) : kAudio_ParamError;
    if (result != noErr || !data || !enabled.load(std::memory_order_relaxed))
        return result;

    const int currentPhase = phase.load(std::memory_order_acquire);
    if (currentPhase == 0) return result;

    const bool outgoing = outgoingDeck.load(std::memory_order_relaxed) == unit;
    const bool incoming = incomingDeck.load(std::memory_order_relaxed) == unit;
    if (!outgoing && !incoming) return result;
    if (!isFloat32(unit, bus)) return result;

    if (currentPhase == 2) {
        applyGain(data, frames, outgoing ? 0.0f : 1.0f);
        return result;
    }

    const uint64_t total = totalFrames.load(std::memory_order_relaxed);
    if (total == 0) return result;

    // Both decks read one shared progress counter. Only the outgoing deck
    // advances it, so two render callbacks do not double the transition speed.
    const uint64_t start = elapsedFrames.load(std::memory_order_relaxed);
    const float p = fminf(1.0f, static_cast<float>(start) / static_cast<float>(total));
    const float angle = p * static_cast<float>(M_PI_2);
    applyGain(data, frames, outgoing ? cosf(angle) : sinf(angle));

    if (outgoing) {
        const uint64_t after = elapsedFrames.fetch_add(frames, std::memory_order_acq_rel) + frames;
        if (after >= total) phase.store(2, std::memory_order_release);
    }
    return result;
}
} // namespace AMV2

extern "C" __attribute__((visibility("default")))
bool AMV2RegisterDeck(AudioUnit unit, int role) {
    if (!unit || (role != AMV2::Outgoing && role != AMV2::Incoming)) return false;
    AMV2::deckFor(role).store(unit, std::memory_order_release);
    AudioStreamBasicDescription asbd{};
    UInt32 size = sizeof(asbd);
    if (AudioUnitGetProperty(unit, kAudioUnitProperty_StreamFormat,
        kAudioUnitScope_Output, 0, &asbd, &size) == noErr && asbd.mSampleRate > 0)
        AMV2::sampleRate.store(static_cast<uint32_t>(asbd.mSampleRate), std::memory_order_relaxed);
    return true;
}

extern "C" __attribute__((visibility("default")))
bool AMV2StartTransition(float seconds) {
    if (!AMV2::enabled.load() || !std::isfinite(seconds) || seconds < 0.25f ||
        !AMV2::outgoingDeck.load() || !AMV2::incomingDeck.load())
        return false;
    const uint64_t rate = AMV2::sampleRate.load();
    AMV2::elapsedFrames.store(0, std::memory_order_release);
    AMV2::totalFrames.store(static_cast<uint64_t>(seconds * rate), std::memory_order_release);
    AMV2::phase.store(1, std::memory_order_release);
    return true;
}

extern "C" __attribute__((visibility("default")))
void AMV2CancelTransition(void) {
    AMV2::phase.store(0, std::memory_order_release);
    AMV2::elapsedFrames.store(0, std::memory_order_release);
}

extern "C" __attribute__((visibility("default")))
void AMV2SetEnabled(bool value) {
    AMV2::enabled.store(value, std::memory_order_release);
    if (!value) AMV2CancelTransition();
}

extern "C" __attribute__((visibility("default")))
float AMV2GetProgress(void) {
    const uint64_t total = AMV2::totalFrames.load();
    if (AMV2::phase.load() == 2) return 1.0f;
    if (!total) return 0.0f;
    return fminf(1.0f, static_cast<float>(AMV2::elapsedFrames.load()) /
                              static_cast<float>(total));
}

__attribute__((constructor)) static void AMV2Initialize(void) {
    struct rebinding binding = {
        "AudioUnitRender", (void *)AMV2::hookedRender,
        (void **)&AMV2::originalRender
    };
    rebind_symbols(&binding, 1);
    NSLog(@"[AutoMixV2] Standalone dual-deck DSP loaded; waiting for Spotify deck adapter.");
}
