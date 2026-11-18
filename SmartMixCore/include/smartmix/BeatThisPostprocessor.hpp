#pragma once

#include <cstddef>
#include <vector>

#include "smartmix/SmartMix.hpp"

namespace smartmix {

struct BeatGrid {
    std::vector<double> beatTimesSeconds;
    std::vector<double> downbeatTimesSeconds;
    double bpm{0.0};
    double beatPeriodSeconds{0.0};
    double beatConfidence{0.0};
    unsigned beatsPerBar{0}; // 3 or 4 when the downbeat interval is reliable
    bool usable{false};
};

// Matches the pinned Beat This! postprocessor: width-7 local-max suppression,
// positive-logit threshold, adjacent-peak deduplication, and downbeat snapping
// to the nearest beat. validStartFrame/validEndFrame select the chunk's
// non-padding region (end is exclusive); model frame rate is normally 50 Hz.
bool postprocessBeatThisLogits(const float* beatLogits,
                               const float* downbeatLogits,
                               std::size_t frameCount,
                               std::size_t validStartFrame,
                               std::size_t validEndFrame,
                               double frameRate,
                               BeatGrid& output);

// Apply a valid full-track grid to an already measured Track. Duration/RMS/
// energy remain from PCM analysis; beat timing and meter are replaced by model
// output. Chunk-local grids must be offset to track time before calling.
bool applyBeatGridToTrack(const BeatGrid& grid, Track& track);

} // namespace smartmix
