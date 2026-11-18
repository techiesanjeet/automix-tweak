#include "smartmix/BeatThisPostprocessor.hpp"

#include <algorithm>
#include <cmath>
#include <limits>
#include <numeric>
#include <vector>

namespace smartmix {
namespace {
std::vector<double> localPeaks(const float* logits, std::size_t start,
                               std::size_t end) {
    std::vector<double> peaks;
    constexpr std::size_t radius = 3; // max_pool1d kernel_size=7
    for (std::size_t frame = start; frame < end; ++frame) {
        const float value = logits[frame];
        if (!(value > 0.0f)) continue;
        const std::size_t left = frame > radius ? std::max(start, frame - radius) : start;
        const std::size_t right = std::min(end - 1, frame + radius);
        float maximum = -std::numeric_limits<float>::infinity();
        for (std::size_t neighbour = left; neighbour <= right; ++neighbour) {
            maximum = std::max(maximum, logits[neighbour]);
        }
        if (value == maximum) peaks.push_back(static_cast<double>(frame));
    }
    return peaks;
}

void deduplicateAdjacent(std::vector<double>& peaks) {
    if (peaks.empty()) return;
    std::vector<double> result;
    result.reserve(peaks.size());
    double mean = peaks.front();
    std::size_t count = 1;
    for (std::size_t i = 1; i < peaks.size(); ++i) {
        if (peaks[i] - mean <= 1.0) {
            ++count;
            mean += (peaks[i] - mean) / static_cast<double>(count);
        } else {
            result.push_back(mean);
            mean = peaks[i];
            count = 1;
        }
    }
    result.push_back(mean);
    peaks.swap(result);
}
}

bool postprocessBeatThisLogits(const float* beatLogits,
                               const float* downbeatLogits,
                               std::size_t frameCount,
                               std::size_t validStartFrame,
                               std::size_t validEndFrame,
                               double frameRate,
                               BeatGrid& output) {
    output = {};
    if (!beatLogits || !downbeatLogits || !frameCount ||
        validStartFrame >= validEndFrame || validEndFrame > frameCount ||
        !std::isfinite(frameRate) || frameRate <= 0.0 || frameRate > 1000.0) {
        return false;
    }
    for (std::size_t i = validStartFrame; i < validEndFrame; ++i) {
        if (!std::isfinite(beatLogits[i]) || !std::isfinite(downbeatLogits[i])) {
            return false;
        }
    }

    auto beatFrames = localPeaks(beatLogits, validStartFrame, validEndFrame);
    auto downbeatFrames = localPeaks(downbeatLogits, validStartFrame, validEndFrame);
    deduplicateAdjacent(beatFrames);
    deduplicateAdjacent(downbeatFrames);

    output.beatTimesSeconds.reserve(beatFrames.size());
    for (double frame : beatFrames) {
        output.beatTimesSeconds.push_back(frame / frameRate);
    }

    // The upstream postprocessor snaps every downbeat activation to its
    // nearest detected beat and removes duplicate snapped positions.
    output.downbeatTimesSeconds.reserve(downbeatFrames.size());
    for (double frame : downbeatFrames) {
        const double time = frame / frameRate;
        const auto nearest = std::min_element(
            output.beatTimesSeconds.begin(), output.beatTimesSeconds.end(),
            [time](double a, double b) {
                return std::abs(a - time) < std::abs(b - time);
            });
        if (nearest != output.beatTimesSeconds.end()) {
            output.downbeatTimesSeconds.push_back(*nearest);
        }
    }
    std::sort(output.downbeatTimesSeconds.begin(), output.downbeatTimesSeconds.end());
    output.downbeatTimesSeconds.erase(
        std::unique(output.downbeatTimesSeconds.begin(),
                    output.downbeatTimesSeconds.end()),
        output.downbeatTimesSeconds.end());

    if (output.beatTimesSeconds.size() < 2) return true;
    std::vector<double> intervals;
    intervals.reserve(output.beatTimesSeconds.size() - 1);
    for (std::size_t i = 1; i < output.beatTimesSeconds.size(); ++i) {
        const double interval = output.beatTimesSeconds[i] -
            output.beatTimesSeconds[i - 1];
        if (interval > 0.0) intervals.push_back(interval);
    }
    if (intervals.empty()) return true;
    const auto middle = intervals.begin() +
        static_cast<std::ptrdiff_t>(intervals.size() / 2);
    std::nth_element(intervals.begin(), middle, intervals.end());
    output.beatPeriodSeconds = *middle;
    if (intervals.size() % 2 == 0) {
        const auto lower = std::max_element(intervals.begin(), middle);
        output.beatPeriodSeconds = (*lower + *middle) * 0.5;
    }
    output.bpm = 60.0 / output.beatPeriodSeconds;

    if (output.downbeatTimesSeconds.size() >= 2) {
        std::vector<double> barIntervals;
        for (std::size_t i = 1; i < output.downbeatTimesSeconds.size(); ++i) {
            const double interval = output.downbeatTimesSeconds[i] -
                output.downbeatTimesSeconds[i - 1];
            if (interval > 0.0) barIntervals.push_back(interval);
        }
        if (!barIntervals.empty()) {
            const auto barMiddle = barIntervals.begin() +
                static_cast<std::ptrdiff_t>(barIntervals.size() / 2);
            std::nth_element(barIntervals.begin(), barMiddle, barIntervals.end());
            double medianBar = *barMiddle;
            if (barIntervals.size() % 2 == 0) {
                const auto lower = std::max_element(barIntervals.begin(), barMiddle);
                medianBar = (*lower + *barMiddle) * 0.5;
            }
            const double beatsPerBar = medianBar / output.beatPeriodSeconds;
            const unsigned roundedMeter = static_cast<unsigned>(std::llround(beatsPerBar));
            if ((roundedMeter == 3 || roundedMeter == 4) &&
                std::abs(beatsPerBar - static_cast<double>(roundedMeter)) < 0.35) {
                output.beatsPerBar = roundedMeter;
            }
        }
    }
    output.usable = std::isfinite(output.bpm) &&
        output.bpm >= 60.0 && output.bpm <= 180.0 &&
        output.beatTimesSeconds.size() >= 4;
    return true;
}

} // namespace smartmix
