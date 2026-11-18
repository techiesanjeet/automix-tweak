#include "smartmix/SmartMix.hpp"
#include <algorithm>
#include <cmath>
#include <complex>
#include <limits>
#include <vector>

namespace smartmix {
namespace {
constexpr double kPi = 3.14159265358979323846;
constexpr std::size_t kFFTSize = 2048;

float monoAt(const AudioView& audio, std::size_t frame) {
    double sum = 0.0;
    for (unsigned channel = 0; channel < audio.channels; ++channel) {
        sum += audio.samples[frame * audio.channels + channel];
    }
    return static_cast<float>(sum / audio.channels);
}

void fft(std::vector<std::complex<double>>& values) {
    const std::size_t n = values.size();
    for (std::size_t i = 1, j = 0; i < n; ++i) {
        std::size_t bit = n >> 1;
        for (; j & bit; bit >>= 1) j ^= bit;
        j ^= bit;
        if (i < j) std::swap(values[i], values[j]);
    }
    for (std::size_t length = 2; length <= n; length <<= 1) {
        const double angle = -2.0 * kPi / static_cast<double>(length);
        const std::complex<double> root(std::cos(angle), std::sin(angle));
        for (std::size_t base = 0; base < n; base += length) {
            std::complex<double> phase(1.0, 0.0);
            for (std::size_t j = 0; j < length / 2; ++j) {
                const auto even = values[base + j];
                const auto odd = values[base + j + length / 2] * phase;
                values[base + j] = even + odd;
                values[base + j + length / 2] = even - odd;
                phase *= root;
            }
        }
    }
}

double alignAtOrAfter(double time, double phase, double period) {
    if (!(period > 0.0) || !std::isfinite(time) || !std::isfinite(phase)) return time;
    return phase + std::ceil((time - phase) / period) * period;
}

double alignAtOrBefore(double time, double phase, double period) {
    if (!(period > 0.0) || !std::isfinite(time) || !std::isfinite(phase)) return time;
    return phase + std::floor((time - phase) / period) * period;
}

// Positive spectral difference is substantially less sensitive to bass-level
// changes than broadband RMS deltas. This runs only on the analysis worker.
std::vector<float> spectralFlux(const AudioView& audio, std::size_t hop) {
    std::vector<float> flux;
    if (audio.frames < kFFTSize || hop == 0) return flux;

    const std::size_t bins = kFFTSize / 2 + 1;
    std::vector<double> previous(bins, 0.0);
    std::vector<double> current(bins, 0.0);
    std::vector<std::complex<double>> spectrum(kFFTSize);
    const std::size_t frameCount = 1 + (audio.frames - kFFTSize) / hop;
    flux.reserve(frameCount);

    for (std::size_t base = 0; base + kFFTSize <= audio.frames; base += hop) {
        for (std::size_t i = 0; i < kFFTSize; ++i) {
            const double window = 0.5 - 0.5 * std::cos(
                2.0 * kPi * static_cast<double>(i) / static_cast<double>(kFFTSize - 1));
            spectrum[i] = std::complex<double>(monoAt(audio, base + i) * window, 0.0);
        }
        fft(spectrum);

        double magnitudeSum = 1e-12;
        for (std::size_t bin = 1; bin < bins; ++bin) {
            current[bin] = std::log1p(std::abs(spectrum[bin]));
            magnitudeSum += current[bin];
        }

        double positiveDifference = 0.0;
        for (std::size_t bin = 1; bin < bins; ++bin) {
            current[bin] /= magnitudeSum;
            positiveDifference += std::max(0.0, current[bin] - previous[bin]);
            previous[bin] = current[bin];
        }
        flux.push_back(static_cast<float>(positiveDifference));
    }
    return flux;
}

double normalizedCorrelation(const std::vector<float>& values, int lag, double mean) {
    double xy = 0.0, xx = 0.0, yy = 0.0;
    for (std::size_t i = static_cast<std::size_t>(lag); i < values.size(); ++i) {
        const double x = static_cast<double>(values[i]) - mean;
        const double y = static_cast<double>(values[i - static_cast<std::size_t>(lag)]) - mean;
        xy += x * y;
        xx += x * x;
        yy += y * y;
    }
    return (xx > 1e-15 && yy > 1e-15) ? xy / std::sqrt(xx * yy) : 0.0;
}
} // namespace

Analysis analyze(const AudioView& audio) {
    Analysis result;
    if (!audio.samples || audio.frames < 2 || !audio.channels || audio.channels > 8 ||
        audio.frames > SIZE_MAX / audio.channels ||
        !std::isfinite(audio.sampleRate) || audio.sampleRate < 8000.0 ||
        audio.sampleRate > 192000.0) return result;

    result.durationSeconds = static_cast<double>(audio.frames) / audio.sampleRate;
    double squareSum = 0.0;
    float peak = 0.0f;
    for (std::size_t frame = 0; frame < audio.frames; ++frame) {
        const float sample = monoAt(audio, frame);
        if (!std::isfinite(sample)) return Analysis{};
        squareSum += static_cast<double>(sample) * sample;
        peak = std::max(peak, std::abs(sample));
    }
    result.rms = std::sqrt(squareSum / static_cast<double>(audio.frames));
    result.peak = peak;
    result.usable = result.rms > 1e-5 && result.durationSeconds > 8.0;
    if (!result.usable) return result;

    const std::size_t hop = std::max<std::size_t>(1,
        static_cast<std::size_t>(std::llround(audio.sampleRate / 100.0)));
    auto flux = spectralFlux(audio, hop);
    if (flux.size() < 400) return result;

    const double mean = [&flux] {
        double sum = 0.0;
        for (float value : flux) sum += value;
        return sum / static_cast<double>(flux.size());
    }();

    const double framesPerSecond = audio.sampleRate / static_cast<double>(hop);
    const int minLag = std::max(2, static_cast<int>(std::floor(framesPerSecond * 60.0 / 180.0)));
    const int maxLag = std::min(static_cast<int>(std::ceil(framesPerSecond * 60.0 / 60.0)),
                                static_cast<int>(flux.size() / 2));
    if (maxLag <= minLag) return result;

    std::vector<double> correlations(static_cast<std::size_t>(maxLag + 1), 0.0);
    double bestCorrelation = -1.0;
    int bestLag = 0;
    for (int lag = minLag; lag <= maxLag; ++lag) {
        const double correlation = normalizedCorrelation(flux, lag, mean);
        correlations[static_cast<std::size_t>(lag)] = correlation;
        if (correlation > bestCorrelation) {
            bestCorrelation = correlation;
            bestLag = lag;
        }
    }
    if (bestLag == 0 || bestCorrelation < 0.05) return result;

    // Prefer the faster pulse when a strong half-time alias is nearly equal.
    // The planner still applies a conservative tempo-ratio policy downstream.
    for (int lag = minLag; lag < bestLag; ++lag) {
        if (correlations[static_cast<std::size_t>(lag)] >= bestCorrelation * 0.96) {
            bestLag = lag;
            bestCorrelation = correlations[static_cast<std::size_t>(lag)];
            break;
        }
    }

    double secondBest = 0.0;
    for (int lag = minLag; lag <= maxLag; ++lag) {
        if (std::abs(lag - bestLag) <= 2) continue;
        secondBest = std::max(secondBest, correlations[static_cast<std::size_t>(lag)]);
    }

    result.beatPeriodSeconds = static_cast<double>(bestLag) / framesPerSecond;
    result.bpm = 60.0 / result.beatPeriodSeconds;

    // Fold the onset curve over the estimated period to estimate beat phase.
    // This is a beat-phase estimate, not a musical downbeat/measure detector.
    std::vector<double> phaseEnergy(static_cast<std::size_t>(bestLag), 0.0);
    for (std::size_t i = 0; i < flux.size(); ++i) {
        phaseEnergy[i % static_cast<std::size_t>(bestLag)] +=
            std::max(0.0, static_cast<double>(flux[i]) - mean);
    }
    const auto phasePeak = std::max_element(phaseEnergy.begin(), phaseEnergy.end());
    const std::size_t phaseIndex = static_cast<std::size_t>(
        std::distance(phaseEnergy.begin(), phasePeak));
    result.firstBeatSeconds = static_cast<double>(phaseIndex) /
        framesPerSecond;

    const double separation = std::clamp(
        (bestCorrelation - std::max(0.0, secondBest)) /
            std::max(bestCorrelation, 1e-9), 0.0, 1.0);
    result.beatConfidence = std::clamp(
        0.8 * bestCorrelation + 0.2 * separation, 0.0, 1.0);
    return result;
}

StreamingAnalyzer::StreamingAnalyzer(double sampleRate, double windowSeconds)
    : sampleRate_(sampleRate) {
    if (!std::isfinite(sampleRate) || sampleRate < 8000.0 || sampleRate > 192000.0 ||
        !std::isfinite(windowSeconds) || windowSeconds < 8.0 || windowSeconds > 120.0) {
        sampleRate_ = 0.0;
        return;
    }
    ring_.resize(static_cast<std::size_t>(std::ceil(sampleRate * windowSeconds)), 0.0f);
}

bool StreamingAnalyzer::append(const AudioView& chunk) {
    if (ring_.empty() || !chunk.samples || !chunk.frames || !chunk.channels ||
        chunk.channels > 8 || chunk.frames > SIZE_MAX / chunk.channels ||
        chunk.frames > UINT64_MAX - framesSeen_ || !std::isfinite(chunk.sampleRate) ||
        std::abs(chunk.sampleRate - sampleRate_) > 0.5) return false;

    // Validate the whole chunk before mutating the ring.
    for (std::size_t i = 0; i < chunk.frames * static_cast<std::size_t>(chunk.channels); ++i) {
        if (!std::isfinite(chunk.samples[i])) return false;
    }
    for (std::size_t frame = 0; frame < chunk.frames; ++frame) {
        double mono = 0.0;
        for (unsigned channel = 0; channel < chunk.channels; ++channel) {
            mono += chunk.samples[frame * chunk.channels + channel];
        }
        ring_[writeIndex_] = static_cast<float>(mono / chunk.channels);
        writeIndex_ = (writeIndex_ + 1) % ring_.size();
        if (framesStored_ < ring_.size()) ++framesStored_;
    }
    framesSeen_ += chunk.frames;
    return true;
}

Analysis StreamingAnalyzer::analyzeLatest() const {
    if (framesStored_ == 0 || ring_.empty()) return {};
    std::vector<float> snapshot(framesStored_);
    const std::size_t start = (writeIndex_ + ring_.size() - framesStored_) % ring_.size();
    for (std::size_t i = 0; i < framesStored_; ++i) {
        snapshot[i] = ring_[(start + i) % ring_.size()];
    }
    Analysis result = analyze({snapshot.data(), snapshot.size(), 1, sampleRate_});
    const double windowOffset = static_cast<double>(framesSeen_ - framesStored_) / sampleRate_;
    if (result.bpm > 0.0) result.firstBeatSeconds += windowOffset;
    result.durationSeconds = static_cast<double>(framesSeen_) / sampleRate_;
    return result;
}

double StreamingAnalyzer::observedSeconds() const {
    return sampleRate_ > 0.0 ? static_cast<double>(framesSeen_) / sampleRate_ : 0.0;
}

Plan planTransition(const Track& outgoing, const Track& incoming,
                    double maxTempoRatio, unsigned bars) {
    Plan plan;
    plan.bars = bars;
    if (!std::isfinite(maxTempoRatio) || maxTempoRatio <= 1.0 ||
        bars < 1 || bars > 16) {
        plan.reason = "invalid planner policy";
        return plan;
    }
    if (!outgoing.analysis.usable || !incoming.analysis.usable) {
        plan.reason = "audio analysis unavailable";
        return plan;
    }
    const auto validTrack = [](const Track& track) {
        const Analysis& analysis = track.analysis;
        return std::isfinite(analysis.bpm) && std::isfinite(analysis.beatPeriodSeconds) &&
            std::isfinite(analysis.firstBeatSeconds) && std::isfinite(analysis.beatConfidence) &&
            std::isfinite(analysis.durationSeconds) && std::isfinite(track.introSeconds) &&
            std::isfinite(track.outroSeconds) && std::isfinite(track.energy) &&
            std::isfinite(track.firstDownbeatSeconds) &&
            analysis.bpm > 0.0 && analysis.beatPeriodSeconds > 0.0 &&
            analysis.durationSeconds > 0.0 && analysis.firstBeatSeconds >= 0.0 &&
            analysis.firstBeatSeconds < analysis.durationSeconds &&
            analysis.beatConfidence >= 0.08 && analysis.beatConfidence <= 1.0 &&
            track.introSeconds >= 0.0 && track.outroSeconds >= 0.0 &&
            track.energy >= 0.0 && track.energy <= 1.0 &&
            (track.beatsPerBar == 0 ||
             ((track.beatsPerBar == 3 || track.beatsPerBar == 4) &&
              track.firstDownbeatSeconds >= 0.0 &&
              track.firstDownbeatSeconds < analysis.durationSeconds));
    };
    if (!validTrack(outgoing) || !validTrack(incoming)) {
        plan.reason = "invalid track analysis or metadata";
        return plan;
    }

    const double ratio = incoming.analysis.bpm / outgoing.analysis.bpm;
    if (ratio < 1.0 / maxTempoRatio || ratio > maxTempoRatio) {
        plan.reason = "tempo mismatch exceeds policy";
        return plan;
    }
    const bool useDownbeatGrid =
        outgoing.beatsPerBar != 0 && incoming.beatsPerBar != 0;
    if (useDownbeatGrid && outgoing.beatsPerBar != incoming.beatsPerBar) {
        plan.reason = "meter mismatch between tracks";
        return plan;
    }

    plan.tempoRatio = ratio;
    plan.incomingPlaybackRate = 1.0 / ratio;
    const double outgoingBeat = outgoing.analysis.beatPeriodSeconds;
    const double incomingBeat = incoming.analysis.beatPeriodSeconds;
    plan.beatsPerBar = useDownbeatGrid ? outgoing.beatsPerBar : 4;
    plan.durationSeconds = outgoingBeat *
        static_cast<double>(plan.beatsPerBar) * bars;

    const double latest = outgoing.analysis.durationSeconds -
        std::max(0.0, outgoing.outroSeconds) - plan.durationSeconds;
    const double earliest = std::max(0.0, outgoing.introSeconds);
    if (latest < earliest) {
        plan.reason = "outgoing track has no full phrase available";
        return plan;
    }
    const double outgoingPhase = useDownbeatGrid
        ? outgoing.firstDownbeatSeconds : outgoing.analysis.firstBeatSeconds;
    const double incomingPhase = useDownbeatGrid
        ? incoming.firstDownbeatSeconds : incoming.analysis.firstBeatSeconds;
    const double outgoingGridPeriod = outgoingBeat *
        static_cast<double>(plan.beatsPerBar);
    const double incomingGridPeriod = incomingBeat *
        static_cast<double>(plan.beatsPerBar);
    plan.startOutgoingSeconds = alignAtOrBefore(
        latest, outgoingPhase, useDownbeatGrid ? outgoingGridPeriod : outgoingBeat);
    if (plan.startOutgoingSeconds < earliest) {
        plan.reason = "no aligned outgoing start inside usable region";
        return plan;
    }
    plan.startIncomingSeconds = alignAtOrAfter(
        std::max(0.0, incoming.introSeconds), incomingPhase,
        useDownbeatGrid ? incomingGridPeriod : incomingBeat);
    if (plan.startOutgoingSeconds + plan.durationSeconds >
            outgoing.analysis.durationSeconds - std::max(0.0, outgoing.outroSeconds) + 1e-6 ||
        plan.startIncomingSeconds + plan.durationSeconds * plan.incomingPlaybackRate >
            incoming.analysis.durationSeconds - incoming.outroSeconds + 1e-6) {
        plan.reason = "not enough prepared audio";
        return plan;
    }

    const double tempoScore = 1.0 - std::abs(std::log(ratio)) / std::log(maxTempoRatio);
    const double energyScore = 1.0 -
        std::min(1.0, std::abs(outgoing.energy - incoming.energy));
    plan.score = std::clamp(0.65 * tempoScore + 0.35 * energyScore, 0.0, 1.0);
    plan.valid = true;
    plan.reason = useDownbeatGrid
        ? "downbeat-aligned phrase candidate"
        : "beat-phase-aligned phrase candidate";
    return plan;
}

void renderEqualPower(const float* outgoing, const float* incoming, float* output,
                      std::size_t frames, unsigned channels,
                      double progressStart, double progressStep) {
    if (!outgoing || !incoming || !output || !channels ||
        !std::isfinite(progressStart) || !std::isfinite(progressStep) ||
        frames > SIZE_MAX / channels) return;

    for (std::size_t frame = 0; frame < frames; ++frame) {
        const double progress = std::clamp(
            progressStart + progressStep * static_cast<double>(frame), 0.0, 1.0);
        const float outgoingGain = static_cast<float>(std::cos(progress * kPi / 2.0));
        const float incomingGain = static_cast<float>(std::sin(progress * kPi / 2.0));
        for (unsigned channel = 0; channel < channels; ++channel) {
            const std::size_t index = frame * channels + channel;
            output[index] = outgoing[index] * outgoingGain +
                incoming[index] * incomingGain;
        }
    }
}
} // namespace smartmix
