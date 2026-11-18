#pragma once

#include <cstddef>
#include <cstdint>
#include <vector>

namespace smartmix {

constexpr std::size_t kBeatThisModelFrames = 1500;
constexpr std::size_t kBeatThisBorderFrames = 6;
constexpr std::size_t kBeatThisChunkStep =
    kBeatThisModelFrames - 2 * kBeatThisBorderFrames;

struct BeatThisChunkSpan {
    std::int64_t startFrame{0};
    std::size_t sourceStartFrame{0};
    std::size_t sourceFrameCount{0};
    std::size_t padLeftFrames{0};
    std::size_t padRightFrames{0};
    std::size_t destinationStartFrame{0};
    std::size_t destinationEndFrame{0};
};

// Reproduces CPJKU Beat This! split_piece(chunk_size=1500, border_size=6,
// avoid_short_end=true). Fixed-shape Core ML inference requires at least
// 1488 spectrogram frames; shorter clips should use the lightweight fallback.
bool makeBeatThisChunkPlan(std::size_t fullFrameCount,
                           std::vector<BeatThisChunkSpan>& spans);

// Copies one planned time-major [frames, 128] slice into a zero-padded
// [1500, 128] model input. Worker thread only.
bool copyBeatThisSpectrogramChunk(const float* fullSpectrogram,
                                  std::size_t fullFrameCount,
                                  const BeatThisChunkSpan& span,
                                  float* chunkSpectrogram);

// Aggregates flat [chunkCount, 1500] beat/downbeat logits using upstream
// overlap_mode="keep_first": earlier chunks win overlapping valid regions.
// Output arrays each hold fullFrameCount values. Worker thread only.
bool aggregateBeatThisChunkLogits(const std::vector<BeatThisChunkSpan>& spans,
                                  const float* chunkBeatLogits,
                                  const float* chunkDownbeatLogits,
                                  std::size_t chunkCount,
                                  std::size_t fullFrameCount,
                                  float* fullBeatLogits,
                                  float* fullDownbeatLogits);

} // namespace smartmix
