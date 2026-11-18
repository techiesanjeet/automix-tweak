#pragma once

#include <cstddef>

namespace smartmix {

// Offline worker-side, windowed-sinc resampling for interleaved Float32 PCM.
// playbackRate > 1 consumes source audio faster and raises pitch; this is
// sample-rate conversion/varispeed, not pitch-preserving time stretching.
// Input and output buffers must not overlap.
bool resampleInterleaved(const float* input, std::size_t inputFrames,
                         unsigned channels, double inputSampleRate,
                         float* output, std::size_t outputFrames,
                         double outputSampleRate, double playbackRate = 1.0);

} // namespace smartmix
