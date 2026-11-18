#include "smartmix/BeatThisSpectrogram.hpp"

#include <algorithm>
#include <array>
#include <cmath>
#include <complex>
#include <cstdint>
#include <limits>

namespace smartmix {
namespace {
constexpr double kPi = 3.14159265358979323846;
constexpr std::size_t kBins = kBeatThisFFTSize / 2 + 1;
constexpr std::size_t kMelPoints = kBeatThisMelBins + 2;

double hzToMel(double hz) {
    constexpr double fSp = 200.0 / 3.0;
    constexpr double minLogHz = 1000.0;
    constexpr double minLogMel = minLogHz / fSp;
    const double logStep = std::log(6.4) / 27.0;
    return hz >= minLogHz ? minLogMel + std::log(hz / minLogHz) / logStep
                          : hz / fSp;
}

double melToHz(double mel) {
    constexpr double fSp = 200.0 / 3.0;
    constexpr double minLogMel = 15.0;
    constexpr double minLogHz = 1000.0;
    const double logStep = std::log(6.4) / 27.0;
    return mel >= minLogMel ? minLogHz * std::exp(logStep * (mel - minLogMel))
                            : fSp * mel;
}

const std::array<double, kBeatThisMelBins * kBins>& melFilterBank() {
    static const auto filters = [] {
        std::array<double, kBeatThisMelBins * kBins> result{};
        std::array<double, kMelPoints> points{};
        const double minMel = hzToMel(30.0);
        const double maxMel = hzToMel(11000.0);
        for (std::size_t i = 0; i < kMelPoints; ++i) {
            const double mel = minMel + (maxMel - minMel) *
                static_cast<double>(i) / static_cast<double>(kMelPoints - 1);
            points[i] = melToHz(mel);
        }
        for (std::size_t mel = 0; mel < kBeatThisMelBins; ++mel) {
            const double lowerWidth = points[mel + 1] - points[mel];
            const double upperWidth = points[mel + 2] - points[mel + 1];
            const double slaneyNorm = 2.0 / (points[mel + 2] - points[mel]);
            for (std::size_t bin = 0; bin < kBins; ++bin) {
                const double frequency = static_cast<double>(bin) *
                    kBeatThisSampleRate / static_cast<double>(kBeatThisFFTSize);
                const double lower = (frequency - points[mel]) / lowerWidth;
                const double upper = (points[mel + 2] - frequency) / upperWidth;
                result[mel * kBins + bin] =
                    std::max(0.0, std::min(lower, upper)) * slaneyNorm;
            }
        }
        return result;
    }();
    return filters;
}

void fft(std::array<std::complex<double>, kBeatThisFFTSize>& values) {
    constexpr std::size_t n = kBeatThisFFTSize;
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

std::size_t reflectIndex(std::int64_t index, std::size_t length) {
    if (length <= 1) return 0;
    const auto end = static_cast<std::int64_t>(length);
    while (index < 0 || index >= end) {
        if (index < 0) index = -index;
        if (index >= end) index = 2 * end - 2 - index;
    }
    return static_cast<std::size_t>(index);
}
} // namespace

std::size_t beatThisSpectrogramFrameCount(std::size_t inputFrames) noexcept {
    return inputFrames ? 1 + inputFrames / kBeatThisHopLength : 0;
}

bool computeBeatThisSpectrogram(const float* input, std::size_t inputFrames,
                                float* output, std::size_t outputFrames) {
    if (!input || !output || inputFrames < 2 ||
        inputFrames > static_cast<std::size_t>(
            std::numeric_limits<std::int64_t>::max() - kBeatThisFFTSize) ||
        outputFrames != beatThisSpectrogramFrameCount(inputFrames) ||
        outputFrames > std::numeric_limits<std::size_t>::max() / kBeatThisMelBins) {
        return false;
    }
    for (std::size_t i = 0; i < inputFrames; ++i) {
        if (!std::isfinite(input[i])) return false;
    }

    const auto& filters = melFilterBank();
    std::array<std::complex<double>, kBeatThisFFTSize> spectrum{};
    constexpr double normalization = 1.0 / std::sqrt(
        static_cast<double>(kBeatThisFFTSize));

    for (std::size_t frame = 0; frame < outputFrames; ++frame) {
        const std::int64_t center = static_cast<std::int64_t>(
            frame * kBeatThisHopLength);
        const std::int64_t start = center -
            static_cast<std::int64_t>(kBeatThisFFTSize / 2);
        for (std::size_t i = 0; i < kBeatThisFFTSize; ++i) {
            const std::int64_t sampleIndex = start + static_cast<std::int64_t>(i);
            const std::size_t reflected = reflectIndex(sampleIndex, inputFrames);
            // torch.hann_window uses the periodic form (denominator N).
            const double window = 0.5 - 0.5 * std::cos(
                2.0 * kPi * static_cast<double>(i) /
                static_cast<double>(kBeatThisFFTSize));
            spectrum[i] = std::complex<double>(
                static_cast<double>(input[reflected]) * window, 0.0);
        }
        fft(spectrum);

        std::array<double, kBins> magnitudes{};
        for (std::size_t bin = 0; bin < kBins; ++bin) {
            magnitudes[bin] = std::abs(spectrum[bin]) * normalization;
        }

        for (std::size_t mel = 0; mel < kBeatThisMelBins; ++mel) {
            double melEnergy = 0.0;
            const std::size_t filterOffset = mel * kBins;
            for (std::size_t bin = 0; bin < kBins; ++bin) {
                melEnergy += magnitudes[bin] * filters[filterOffset + bin];
            }
            output[frame * kBeatThisMelBins + mel] =
                static_cast<float>(std::log1p(1000.0 * melEnergy));
        }
    }
    return true;
}

} // namespace smartmix
