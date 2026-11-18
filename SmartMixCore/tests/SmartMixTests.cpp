#include <algorithm>
#include "smartmix/SmartMix.hpp"
#include "smartmix/PreparedPCM.hpp"
#include "smartmix/Resampler.hpp"
#include "smartmix/BeatThisSpectrogram.hpp"
#include "smartmix/BeatThisPostprocessor.hpp"
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
    std::vector<float> cBeatLogits(1500, -5.0f);
    std::vector<float> cDownbeatLogits(1500, -5.0f);
    for (std::size_t frame = 100; frame <= 500; frame += 25) {
        cBeatLogits[frame] = 5.0f;
    }
    for (std::size_t frame : {100u, 200u, 300u, 400u, 500u}) {
        cDownbeatLogits[frame] = 6.0f;
    }
    assert(SMApplyBeatThisLogitsToTrack(
        cBeatLogits.data(), cDownbeatLogits.data(), 1500, 6, 1494, 50.0,
        &outgoing) == 1);
    assert(SMApplyBeatThisLogitsToTrack(
        cBeatLogits.data(), cDownbeatLogits.data(), 1500, 6, 1494, 50.0,
        &incoming) == 1);
    assert(outgoing.beatsPerBar == 4 && incoming.beatsPerBar == 4);
    assert(std::abs(outgoing.firstDownbeatSeconds - 2.0) < 1e-6);
    SMPlan cPlan{};
    assert(SMPlanTransition(&outgoing, &incoming, 1.08, 8, &cPlan) == 1);
    assert(cPlan.valid && cPlan.durationSeconds > 0.0 && cPlan.beatsPerBar == 4);

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

    BeatGrid plannerGrid;
    plannerGrid.usable = true;
    plannerGrid.bpm = 120.0;
    plannerGrid.beatPeriodSeconds = 0.5;
    plannerGrid.beatConfidence = 0.99;
    plannerGrid.beatsPerBar = 4;
    plannerGrid.beatTimesSeconds = {2.0, 2.5, 3.0, 3.5, 4.0};
    plannerGrid.downbeatTimesSeconds = {2.0, 4.0, 6.0};
    Track xDownbeat = x;
    Track yDownbeat = y;
    assert(applyBeatGridToTrack(plannerGrid, xDownbeat));
    assert(applyBeatGridToTrack(plannerGrid, yDownbeat));
    assert(std::abs(xDownbeat.analysis.bpm - 120.0) < 1e-6);
    const auto downbeatPlan = planTransition(xDownbeat, yDownbeat);
    assert(downbeatPlan.valid && downbeatPlan.beatsPerBar == 4);
    const double phrasePeriod = xDownbeat.analysis.beatPeriodSeconds * 4.0;
    const double outgoingPhraseIndex =
        (downbeatPlan.startOutgoingSeconds - xDownbeat.firstDownbeatSeconds) /
        phrasePeriod;
    const double incomingPhraseIndex =
        (downbeatPlan.startIncomingSeconds - yDownbeat.firstDownbeatSeconds) /
        phrasePeriod;
    assert(std::abs(outgoingPhraseIndex - std::round(outgoingPhraseIndex)) < 1e-6);
    assert(std::abs(incomingPhraseIndex - std::round(incomingPhraseIndex)) < 1e-6);
    yDownbeat.beatsPerBar = 3;
    assert(!planTransition(xDownbeat, yDownbeat).valid);

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

    // Verify callback-safe prepared PCM substitution, exact frame boundaries,
    // deterministic rejoin, and cancellation on source discontinuities.
    PreparedPCMSubstitution prepared(8, 2);
    const float rendered[8] = {1, 10, 2, 20, 3, 30, 4, 40};
    assert(prepared.arm(rendered, 4, 2, sampleRate, 7, 100));

    float beforeStart[4] = {-1, -1, -1, -1};
    assert(!prepared.process(beforeStart, 2, 2, sampleRate, 7, 98));
    for (float value : beforeStart) assert(value == -1);

    float crossing[8] = {-2, -2, -2, -2, -2, -2, -2, -2};
    assert(prepared.process(crossing, 4, 2, sampleRate, 7, 98));
    assert(crossing[0] == -2 && crossing[1] == -2 &&
           crossing[2] == -2 && crossing[3] == -2);
    assert(crossing[4] == 1 && crossing[5] == 10 &&
           crossing[6] == 2 && crossing[7] == 20);
    assert(prepared.state() == PreparedPCMSubstitution::State::Playing);

    float tail[4] = {-3, -3, -3, -3};
    assert(prepared.process(tail, 2, 2, sampleRate, 7, 102));
    assert(tail[0] == 3 && tail[1] == 30 && tail[2] == 4 && tail[3] == 40);
    assert(prepared.state() == PreparedPCMSubstitution::State::Completed);

    float rejoined[4] = {-4, -4, -4, -4};
    assert(!prepared.process(rejoined, 2, 2, sampleRate, 7, 104));
    for (float value : rejoined) assert(value == -4);

    assert(prepared.arm(rendered, 4, 2, sampleRate, 8, 200));
    float wrongEpoch[4] = {-5, -5, -5, -5};
    assert(!prepared.process(wrongEpoch, 2, 2, sampleRate, 9, 200));
    assert(prepared.state() == PreparedPCMSubstitution::State::Cancelled);

    assert(prepared.arm(rendered, 4, 2, sampleRate, 8, 300));
    prepared.requestCancel();
    assert(prepared.state() == PreparedPCMSubstitution::State::CancelRequested);
    float cancelled[4] = {-6, -6, -6, -6};
    assert(!prepared.process(cancelled, 2, 2, sampleRate, 8, 300));
    assert(prepared.state() == PreparedPCMSubstitution::State::Cancelled);

    assert(prepared.arm(rendered, 4, 2, sampleRate, 8, 400));
    float late[4] = {-7, -7, -7, -7};
    assert(!prepared.process(late, 2, 2, sampleRate, 8, 401));
    assert(prepared.state() == PreparedPCMSubstitution::State::Cancelled);

    float invalidPCM[2] = {0.0f, std::numeric_limits<float>::infinity()};
    assert(!prepared.arm(invalidPCM, 1, 2, sampleRate, 8, 500));

    // Offline windowed-sinc conversion preserves a 1 kHz tone and varispeed
    // changes tempo/pitch as documented (pitch-preserving stretch is future work).
    constexpr double inputRate = 48000.0;
    constexpr double outputRate = 44100.0;
    std::vector<float> tone(4800);
    for (std::size_t i = 0; i < tone.size(); ++i) {
        tone[i] = static_cast<float>(0.5 * std::sin(
            2.0 * 3.141592653589793 * 1000.0 * static_cast<double>(i) / inputRate));
    }
    auto estimateFrequency = [](const std::vector<float>& samples, double rate) {
        std::size_t positiveCrossings = 0;
        for (std::size_t i = 1; i < samples.size(); ++i) {
            if (samples[i - 1] <= 0.0f && samples[i] > 0.0f) ++positiveCrossings;
        }
        return static_cast<double>(positiveCrossings) * rate /
            static_cast<double>(samples.size());
    };
    std::vector<float> resampled(4410);
    assert(resampleInterleaved(tone.data(), tone.size(), 1, inputRate,
                               resampled.data(), resampled.size(), outputRate, 1.0));
    assert(std::abs(estimateFrequency(resampled, outputRate) - 1000.0) < 40.0);
    std::vector<float> varispeed(4200);
    assert(resampleInterleaved(tone.data(), tone.size(), 1, inputRate,
                               varispeed.data(), varispeed.size(), outputRate, 1.05));
    assert(std::abs(estimateFrequency(varispeed, outputRate) - 1050.0) < 45.0);
    assert(!resampleInterleaved(tone.data(), tone.size(), 1, inputRate,
                                varispeed.data(), 5000, outputRate, 1.0));

    // The Beat This! preprocessing path uses centered 1024-point STFT frames
    // and emits 128 Slaney log-mel bins every 441 samples.
    constexpr std::size_t modelAudioFrames = 22050 * 2;
    std::vector<float> modelAudio(modelAudioFrames);
    for (std::size_t i = 0; i < modelAudio.size(); ++i) {
        modelAudio[i] = static_cast<float>(0.2 * std::sin(
            2.0 * 3.141592653589793 * 440.0 * static_cast<double>(i) / 22050.0));
    }
    const std::size_t melFrames = beatThisSpectrogramFrameCount(modelAudio.size());
    assert(melFrames == 101);
    std::vector<float> melSpectrogram(melFrames * kBeatThisMelBins);
    assert(computeBeatThisSpectrogram(modelAudio.data(), modelAudio.size(),
                                      melSpectrogram.data(), melFrames));
    bool hasEnergy = false;
    for (float value : melSpectrogram) {
        assert(std::isfinite(value) && value >= 0.0f);
        hasEnergy = hasEnergy || value > 0.0f;
    }
    assert(hasEnergy);
    assert(!computeBeatThisSpectrogram(modelAudio.data(), modelAudio.size(),
                                       melSpectrogram.data(), melFrames - 1));

    // Beat This postprocessing: local maxima, adjacent peak merging, and
    // downbeat snapping to the nearest detected beat.
    std::vector<float> beatLogits(1500, -5.0f);
    std::vector<float> downbeatLogits(1500, -5.0f);
    for (std::size_t frame = 100; frame <= 500; frame += 25) {
        beatLogits[frame] = 5.0f;
    }
    beatLogits[501] = 5.0f; // adjacent activation merges to one midpoint
    for (std::size_t frame : {100u, 202u, 300u, 400u, 500u}) {
        downbeatLogits[frame] = 6.0f;
    }
    BeatGrid beatGrid;
    assert(postprocessBeatThisLogits(beatLogits.data(), downbeatLogits.data(),
                                     1500, 6, 1494, 50.0, beatGrid));
    assert(beatGrid.usable && std::abs(beatGrid.bpm - 120.0) < 1e-6);
    assert(beatGrid.beatsPerBar == 4);
    assert(beatGrid.beatTimesSeconds.size() == 17);
    assert(beatGrid.downbeatTimesSeconds.size() == 5);
    assert(std::abs(beatGrid.downbeatTimesSeconds[1] - 4.0) < 1e-6);
    std::vector<float> sparseDownbeats(1500, -5.0f);
    sparseDownbeats[100] = 6.0f;
    sparseDownbeats[300] = 6.0f;
    BeatGrid uncertainMeter;
    assert(postprocessBeatThisLogits(beatLogits.data(), sparseDownbeats.data(),
                                     1500, 6, 1494, 50.0, uncertainMeter));
    assert(uncertainMeter.beatsPerBar == 0);
    beatLogits[1200] = std::numeric_limits<float>::quiet_NaN();
    assert(!postprocessBeatThisLogits(beatLogits.data(), downbeatLogits.data(),
                                      1500, 6, 1494, 50.0, beatGrid));

    std::cout << "SmartMix DSP tests passed; BPM=" << analysis.bpm
              << " confidence=" << analysis.beatConfidence << "\n";
}
