#include "smartmix/AudioInputAdapter.hpp"
#include "smartmix/BeatThisSpectrogram.hpp"
#include "smartmix/Resampler.hpp"

#include <cmath>
#include <limits>
#include <vector>

namespace smartmix {

bool prepareBeatThisMono22050(const float *left, const float *right,
                              std::size_t inputFrames, double inputSampleRate,
                              std::vector<float> &monoOutput) {
    monoOutput.clear();
    if (!left || !right || inputFrames < 2 ||
        !std::isfinite(inputSampleRate) || inputSampleRate < 8000.0 ||
        inputSampleRate > 192000.0 ||
        inputFrames > std::numeric_limits<std::size_t>::max() / sizeof(float)) {
        return false;
    }

    std::vector<float> downmixed(inputFrames);
    for (std::size_t i = 0; i < inputFrames; ++i) {
        if (!std::isfinite(left[i]) || !std::isfinite(right[i])) return false;
        downmixed[i] = 0.5f * (left[i] + right[i]);
    }

    const long double lastSourcePosition =
        static_cast<long double>(inputFrames - 1) *
        static_cast<long double>(kBeatThisSampleRate) /
        static_cast<long double>(inputSampleRate);
    if (!std::isfinite(static_cast<double>(lastSourcePosition)) ||
        lastSourcePosition < 1.0L ||
        lastSourcePosition >= static_cast<long double>(
            std::numeric_limits<std::size_t>::max() - 1)) return false;

    const std::size_t outputFrames =
        static_cast<std::size_t>(std::floor(lastSourcePosition)) + 1;
    std::vector<float> converted(outputFrames);
    if (!resampleInterleaved(downmixed.data(), downmixed.size(), 1,
                             inputSampleRate, converted.data(),
                             converted.size(), kBeatThisSampleRate)) {
        return false;
    }
    monoOutput.swap(converted);
    return true;
}

} // namespace smartmix
