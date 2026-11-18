#pragma once

#include <cstddef>
#include <vector>

namespace smartmix {

// Worker-thread adapter for the planar Float32 stereo source format observed
// in Taurus Beta. Downmixes to mono and converts to Beat This' 22050 Hz input.
// Allocates output storage; never call from an audio render callback.
bool prepareBeatThisMono22050(const float *left, const float *right,
                              std::size_t inputFrames, double inputSampleRate,
                              std::vector<float> &monoOutput);

} // namespace smartmix
