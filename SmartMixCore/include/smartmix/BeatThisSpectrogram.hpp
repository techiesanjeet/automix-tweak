#pragma once

#include <cstddef>

namespace smartmix {

constexpr double kBeatThisSampleRate = 22050.0;
constexpr std::size_t kBeatThisHopLength = 441;
constexpr std::size_t kBeatThisFFTSize = 1024;
constexpr std::size_t kBeatThisMelBins = 128;

// Number of centered STFT frames produced by the pinned upstream contract.
std::size_t beatThisSpectrogramFrameCount(std::size_t inputFrames) noexcept;

// Reproduces CPJKU Beat This! LogMelSpect settings for mono 22050 Hz Float32:
// n_fft=1024, hop=441, f_min=30, f_max=11000, Slaney mel scale/norm,
// frame-length normalization, magnitude power=1, and log1p(1000 * mel).
// Runs on a worker; output must hold frameCount * 128 floats in time-major order.
bool computeBeatThisSpectrogram(const float* mono22050,
                                std::size_t inputFrames,
                                float* output,
                                std::size_t outputFrames);

} // namespace smartmix
