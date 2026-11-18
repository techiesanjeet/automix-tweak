#include "smartmix/BeatThisChunking.hpp"
#include "smartmix/BeatThisSpectrogram.hpp"

#include <algorithm>
#include <cmath>
#include <limits>
#include <vector>

namespace smartmix {

bool makeBeatThisChunkPlan(std::size_t fullFrameCount,
                           std::vector<BeatThisChunkSpan>& spans) {
    spans.clear();
    if (fullFrameCount < kBeatThisChunkStep ||
        fullFrameCount > static_cast<std::size_t>(
            std::numeric_limits<std::int64_t>::max() -
            static_cast<std::int64_t>(kBeatThisModelFrames))) {
        return false;
    }

    const auto total = static_cast<std::int64_t>(fullFrameCount);
    const auto border = static_cast<std::int64_t>(kBeatThisBorderFrames);
    const auto chunkSize = static_cast<std::int64_t>(kBeatThisModelFrames);
    const auto step = static_cast<std::int64_t>(kBeatThisChunkStep);
    std::vector<std::int64_t> starts;
    try {
        for (std::int64_t start = -border; start < total - border; start += step) {
            starts.push_back(start);
        }
        if (starts.empty()) return false;
        if (fullFrameCount > kBeatThisChunkStep) {
            starts.back() = total - (chunkSize - border);
        }
        spans.reserve(starts.size());
        for (const std::int64_t start : starts) {
            const std::int64_t end = start + chunkSize;
            const std::int64_t sourceStart = std::max<std::int64_t>(start, 0);
            const std::int64_t sourceEnd = std::min<std::int64_t>(end, total);
            if (sourceEnd < sourceStart) return false;

            BeatThisChunkSpan span;
            span.startFrame = start;
            span.sourceStartFrame = static_cast<std::size_t>(sourceStart);
            span.sourceFrameCount =
                static_cast<std::size_t>(sourceEnd - sourceStart);
            span.padLeftFrames = static_cast<std::size_t>(
                std::max<std::int64_t>(0, -start));
            span.padRightFrames = static_cast<std::size_t>(
                std::max<std::int64_t>(0, std::min<std::int64_t>(
                    border, end - total)));
            if (span.padLeftFrames + span.sourceFrameCount +
                    span.padRightFrames != kBeatThisModelFrames ||
                span.padLeftFrames > kBeatThisBorderFrames ||
                span.padRightFrames > kBeatThisBorderFrames) {
                spans.clear();
                return false;
            }

            const std::int64_t validStart = start + border;
            const std::int64_t validEnd = start + chunkSize - border;
            const std::int64_t clippedStart = std::max<std::int64_t>(0, validStart);
            const std::int64_t clippedEnd = std::min<std::int64_t>(total, validEnd);
            if (clippedEnd <= clippedStart) {
                spans.clear();
                return false;
            }
            span.destinationStartFrame = static_cast<std::size_t>(clippedStart);
            span.destinationEndFrame = static_cast<std::size_t>(clippedEnd);
            spans.push_back(span);
        }
    } catch (...) {
        spans.clear();
        return false;
    }

    // Ensure every frame has at least one valid prediction region. Overlaps
    // are expected and are resolved by the keep-first aggregator.
    std::size_t coveredUntil = 0;
    for (const auto& span : spans) {
        if (span.destinationStartFrame > coveredUntil) {
            spans.clear();
            return false;
        }
        coveredUntil = std::max(coveredUntil, span.destinationEndFrame);
    }
    if (coveredUntil != fullFrameCount) {
        spans.clear();
        return false;
    }
    return true;
}

bool copyBeatThisSpectrogramChunk(const float* fullSpectrogram,
                                  std::size_t fullFrameCount,
                                  const BeatThisChunkSpan& span,
                                  float* chunkSpectrogram) {
    if (!fullSpectrogram || !chunkSpectrogram ||
        span.sourceStartFrame > fullFrameCount ||
        span.sourceFrameCount > fullFrameCount - span.sourceStartFrame ||
        span.padLeftFrames + span.sourceFrameCount + span.padRightFrames !=
            kBeatThisModelFrames ||
        span.padLeftFrames > kBeatThisBorderFrames ||
        span.padRightFrames > kBeatThisBorderFrames ||
        span.sourceFrameCount == 0 ||
        fullFrameCount > std::numeric_limits<std::size_t>::max() /
            kBeatThisMelBins) {
        return false;
    }

    std::fill_n(chunkSpectrogram,
                kBeatThisModelFrames * kBeatThisMelBins, 0.0f);
    const float* source = fullSpectrogram +
        span.sourceStartFrame * kBeatThisMelBins;
    float* destination = chunkSpectrogram +
        span.padLeftFrames * kBeatThisMelBins;
    std::copy_n(source, span.sourceFrameCount * kBeatThisMelBins, destination);
    return true;
}

bool aggregateBeatThisChunkLogits(const std::vector<BeatThisChunkSpan>& spans,
                                  const float* chunkBeatLogits,
                                  const float* chunkDownbeatLogits,
                                  std::size_t chunkCount,
                                  std::size_t fullFrameCount,
                                  float* fullBeatLogits,
                                  float* fullDownbeatLogits) {
    if (spans.empty() || !chunkBeatLogits || !chunkDownbeatLogits ||
        !fullBeatLogits || !fullDownbeatLogits ||
        chunkCount != spans.size() || fullFrameCount < kBeatThisChunkStep ||
        chunkCount > std::numeric_limits<std::size_t>::max() /
            kBeatThisModelFrames) {
        return false;
    }

    try {
        std::vector<unsigned char> coverage(fullFrameCount, 0);
        std::fill_n(fullBeatLogits, fullFrameCount, -1000.0f);
        std::fill_n(fullDownbeatLogits, fullFrameCount, -1000.0f);

        // Reverse order makes the earliest chunk overwrite later chunks,
        // matching the upstream "keep_first" overlap policy.
        for (std::size_t reverse = chunkCount; reverse > 0; --reverse) {
            const std::size_t chunk = reverse - 1;
            const auto& span = spans[chunk];
            if (span.destinationStartFrame >= span.destinationEndFrame ||
                span.destinationEndFrame > fullFrameCount) return false;
            const float* beat = chunkBeatLogits +
                chunk * kBeatThisModelFrames;
            const float* downbeat = chunkDownbeatLogits +
                chunk * kBeatThisModelFrames;
            for (std::size_t frame = span.destinationStartFrame;
                 frame < span.destinationEndFrame; ++frame) {
                const std::int64_t localFrame =
                    static_cast<std::int64_t>(frame) - span.startFrame;
                if (localFrame < static_cast<std::int64_t>(kBeatThisBorderFrames) ||
                    localFrame >= static_cast<std::int64_t>(
                        kBeatThisModelFrames - kBeatThisBorderFrames)) {
                    return false;
                }
                const float beatValue = beat[static_cast<std::size_t>(localFrame)];
                const float downbeatValue =
                    downbeat[static_cast<std::size_t>(localFrame)];
                if (!std::isfinite(beatValue) || !std::isfinite(downbeatValue)) {
                    return false;
                }
                fullBeatLogits[frame] = beatValue;
                fullDownbeatLogits[frame] = downbeatValue;
                coverage[frame] = 1;
            }
        }
        return std::all_of(coverage.begin(), coverage.end(),
                           [](unsigned char value) { return value != 0; });
    } catch (...) {
        return false;
    }
}

} // namespace smartmix
