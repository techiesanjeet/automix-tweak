#include "smartmix/Resampler.hpp"

#include <algorithm>
#include <cmath>
#include <cstddef>
#include <limits>

namespace smartmix {
namespace {
constexpr double kPi = 3.14159265358979323846;
constexpr int kHalfTaps = 16;

double sinc(double value) {
    if (std::abs(value) < 1e-12) return 1.0;
    const double x = kPi * value;
    return std::sin(x) / x;
}
}

bool resampleInterleaved(const float* input, std::size_t inputFrames,
                         unsigned channels, double inputSampleRate,
                         float* output, std::size_t outputFrames,
                         double outputSampleRate, double playbackRate) {
    if (!input || !output || input == output || !inputFrames || !outputFrames ||
        !channels || channels > 8 ||
        inputFrames > std::numeric_limits<std::size_t>::max() / channels ||
        outputFrames > std::numeric_limits<std::size_t>::max() / channels ||
        !std::isfinite(inputSampleRate) || !std::isfinite(outputSampleRate) ||
        !std::isfinite(playbackRate) || inputSampleRate < 8000.0 ||
        inputSampleRate > 192000.0 || outputSampleRate < 8000.0 ||
        outputSampleRate > 192000.0 || playbackRate < 0.5 || playbackRate > 2.0) {
        return false;
    }

    const std::size_t inputSamples = inputFrames * static_cast<std::size_t>(channels);
    for (std::size_t i = 0; i < inputSamples; ++i) {
        if (!std::isfinite(input[i])) return false;
    }

    const double sourceStep = inputSampleRate * playbackRate / outputSampleRate;
    const double finalSourcePosition = static_cast<double>(outputFrames - 1) * sourceStep;
    if (!std::isfinite(sourceStep) || !std::isfinite(finalSourcePosition) ||
        finalSourcePosition >= static_cast<double>(inputFrames)) return false;

    // Reduce the cutoff whenever source samples are consumed faster than the
    // output clock, preventing aliases during varispeed/downsampling.
    const double cutoff = 0.98 * std::min(1.0, outputSampleRate /
        (inputSampleRate * playbackRate));

    for (std::size_t frame = 0; frame < outputFrames; ++frame) {
        const double position = static_cast<double>(frame) * sourceStep;
        const auto center = static_cast<std::int64_t>(std::floor(position));
        for (unsigned channel = 0; channel < channels; ++channel) {
            double weighted = 0.0;
            double weightSum = 0.0;
            for (int tap = -kHalfTaps + 1; tap <= kHalfTaps; ++tap) {
                const std::int64_t sourceIndex = center + tap;
                if (sourceIndex < 0 ||
                    sourceIndex >= static_cast<std::int64_t>(inputFrames)) continue;
                const double distance = position - static_cast<double>(sourceIndex);
                if (std::abs(distance) >= static_cast<double>(kHalfTaps)) continue;
                const double window = 0.5 + 0.5 * std::cos(
                    kPi * distance / static_cast<double>(kHalfTaps));
                const double weight = cutoff * sinc(cutoff * distance) * window;
                weighted += input[static_cast<std::size_t>(sourceIndex) * channels +
                                  channel] * weight;
                weightSum += weight;
            }
            output[frame * channels + channel] =
                weightSum > 1e-12 ? static_cast<float>(weighted / weightSum) : 0.0f;
        }
    }
    return true;
}

} // namespace smartmix
