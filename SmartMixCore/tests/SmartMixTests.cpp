#include <algorithm>
#include "smartmix/SmartMix.hpp"
#include "smartmix/SmartMixBridge.h"
#include <cassert>
#include <cmath>
#include <iostream>
#include <limits>
#include <vector>

namespace {
std::vector<float> clickTrack(double sampleRate, double seconds, double bpm) {
    const std::size_t frames = static_cast<std::size_t>(sampleRate * seconds);
    const double period = 60.0 / bpm;
    std::vector<float> audio(frames);
    for (std::size_t i = 0; i < frames; ++i) {
        const double time = static_cast<double>(i) / sampleRate;
        const double phase = std::fmod(time, period);
        audio[i] = phase < 0.012
            ? static_cast<float>(0.7 * std::exp(-phase * 350.0) *
                std::sin(2.0 * 3.141592653589793 * 1200.0 * time))
            : 0.0f;
    }
    return audio;
}
}

int main() {
    using namespace smartmix;
    constexpr double sampleRate = 44100.0;
    constexpr std::size_t frames = static_cast<std::size_t>(sampleRate * 32.0);
    auto audio = clickTrack(sampleRate, 32.0, 120.0);

    const auto analysis = analyze({audio.data(), audio.size(), 1, sampleRate});
    assert(analysis.usable && analysis.rms > 0.0 && analysis.peak <= 1.0);
    assert(std::abs(analysis.bpm - 120.0) < 4.0);
    assert(analysis.beatConfidence >= 0.08);
    assert(analysis.firstBeatSeconds >= 0.0 && analysis.firstBeatSeconds < 1.0);

    // Exercise a different tempo and interleaved stereo downmix.
    auto slower = clickTrack(sampleRate, 24.0, 100.0);
    std::vector<float> stereo(slower.size() * 2);
    for (std::size_t i = 0; i < slower.size(); ++i) {
        stereo[i * 2] = slower[i];
        stereo[i * 2 + 1] = slower[i];
    }
    const auto stereoAnalysis = analyze({stereo.data(), slower.size(), 2, sampleRate});
    assert(stereoAnalysis.usable);
    assert(std::abs(stereoAnalysis.bpm - 100.0) < 4.0);

    StreamingAnalyzer stream(sampleRate, 16.0);
    const std::size_t chunkFrames = static_cast<std::size_t>(sampleRate * 4.0);
    for (std::size_t offset = 0; offset < frames; offset += chunkFrames) {
        const std::size_t count = std::min(chunkFrames, frames - offset);
        assert(stream.append({audio.data() + offset, count, 1, sampleRate}));
    }
    const auto streamed = stream.analyzeLatest();
    assert(streamed.usable && std::abs(streamed.bpm - 120.0) < 4.0);
    assert(std::abs(streamed.durationSeconds - 32.0) < 0.01);
    assert(std::abs(stream.observedSeconds() - 32.0) < 0.01);
    assert(!stream.append({audio.data(), 128, 1, 48000.0}));

    const double beforeMalformed = stream.observedSeconds();
    float malformed[4] = {0.1f, 0.2f, std::numeric_limits<float>::quiet_NaN(), 0.4f};
    assert(!stream.append({malformed, 4, 1, sampleRate}));
    assert(std::abs(stream.observedSeconds() - beforeMalformed) < 1e-12);

    // Exercise the stable C ABI used by Objective-C++/runtime adapters.
    SMAnalysis cAnalysis{};
    assert(SMAnalyzePCM(audio.data(), audio.size(), 1, sampleRate, &cAnalysis) == 1);
    assert(std::abs(cAnalysis.bpm - analysis.bpm) < 1e-9);

    SMTrack outgoing{};
    outgoing.analysis = cAnalysis;
    outgoing.energy = 0.6;
    outgoing.outroSeconds = 8.0;
    SMTrack incoming{};
    incoming.analysis = cAnalysis;
    incoming.energy = 0.55;
    SMPlan cPlan{};
    assert(SMPlanTransition(&outgoing, &incoming, 1.08, 8, &cPlan) == 1);
    assert(cPlan.valid && cPlan.durationSeconds > 0.0);

    void *cStream = SMCreateStreamingAnalyzer(sampleRate, 16.0);
    assert(cStream != nullptr);
    assert(SMAppendPCM(cStream, audio.data(), chunkFrames, 1, sampleRate) == 1);
    SMAnalysis cStreamAnalysis{};
    assert(SMAnalyzeLatest(cStream, &cStreamAnalysis) == 0 ||
           cStreamAnalysis.durationSeconds > 0.0);
    assert(SMObservedSeconds(cStream) > 0.0);
    SMDestroyStreamingAnalyzer(cStream);

    std::vector<float> left(256, 1.0f), right(256, 1.0f), output(256);
    renderEqualPower(left.data(), right.data(), output.data(), 256, 1, 0.0, 1.0 / 255.0);
    assert(std::abs(output.front() - 1.0f) < 1e-5);
    assert(std::abs(output.back() - 1.0f) < 1e-5);
    for (float value : output) assert(std::isfinite(value));

    Track x;
    x.analysis = analysis;
    x.energy = 0.6;
    x.outroSeconds = 8.0;
    Track y;
    y.analysis = analysis;
    y.energy = 0.55;
    const auto plan = planTransition(x, y);
    assert(plan.valid && plan.durationSeconds > 0.0 && plan.incomingPlaybackRate == 1.0);

    Track edge = x;
    edge.analysis.durationSeconds = 31.9;
    const auto edgePlan = planTransition(edge, y);
    assert(edgePlan.valid);
    assert(edgePlan.startOutgoingSeconds + edgePlan.durationSeconds <=
           edge.analysis.durationSeconds - edge.outroSeconds + 1e-6);

    const double outgoingBeats =
        (plan.startOutgoingSeconds - analysis.firstBeatSeconds) /
        analysis.beatPeriodSeconds;
    const double incomingBeats =
        (plan.startIncomingSeconds - analysis.firstBeatSeconds) /
        analysis.beatPeriodSeconds;
    assert(std::abs(outgoingBeats - std::round(outgoingBeats)) < 1e-6);
    assert(std::abs(incomingBeats - std::round(incomingBeats)) < 1e-6);
    assert(!planTransition(x, y, 1.0, 8).valid);
    assert(!planTransition(x, y, 1.08, 0).valid);

    // A faster playback rate consumes more incoming-source seconds than
    // transition wall-clock seconds; reject a buffer that would run dry.
    Track slowerIncoming = y;
    slowerIncoming.analysis.bpm = 110.0;
    slowerIncoming.analysis.beatPeriodSeconds = 60.0 / 110.0;
    slowerIncoming.analysis.durationSeconds = 17.2;
    assert(!planTransition(x, slowerIncoming, 1.1, 8).valid);
    slowerIncoming.analysis.durationSeconds = 18.0;
    const auto rateAdjustedPlan = planTransition(x, slowerIncoming, 1.1, 8);
    assert(rateAdjustedPlan.valid && rateAdjustedPlan.incomingPlaybackRate > 1.0);

    // Respect the incoming track's trailing silence and reject corrupt metadata.
    slowerIncoming.outroSeconds = 1.0;
    slowerIncoming.analysis.durationSeconds = 18.0;
    assert(!planTransition(x, slowerIncoming, 1.1, 8).valid);
    slowerIncoming.outroSeconds = 0.0;
    slowerIncoming.energy = std::numeric_limits<double>::quiet_NaN();
    assert(!planTransition(x, slowerIncoming, 1.1, 8).valid);

    std::cout << "SmartMix DSP tests passed; BPM=" << analysis.bpm
              << " confidence=" << analysis.beatConfidence << "\n";
}
