#pragma once
#include <cstddef>
#include <cstdint>
#include <vector>

namespace smartmix {
struct AudioView {
  const float* samples{}; std::size_t frames{}; unsigned channels{1}; double sampleRate{44100.0};
};
struct Analysis {
  double bpm{0.0}; double beatPeriodSeconds{0.0}; double firstBeatSeconds{0.0};
  double beatConfidence{0.0}; double rms{0.0}; double peak{0.0};
  double durationSeconds{0.0}; bool usable{false};
};
struct Track {
  Analysis analysis; double introSeconds{0.0}; double outroSeconds{0.0};
  double energy{0.0}; bool vocalsLikely{false};
};
struct Plan {
  bool valid{false}; double startOutgoingSeconds{0.0}; double startIncomingSeconds{0.0};
  double durationSeconds{0.0}; double tempoRatio{1.0}; double score{0.0};
  unsigned bars{0}; const char* reason{"not evaluated"};
};
Analysis analyze(const AudioView& audio);
Plan planTransition(const Track& outgoing, const Track& incoming,
                    double maxTempoRatio = 1.08, unsigned bars = 8);
void renderEqualPower(const float* outgoing, const float* incoming, float* output,
                      std::size_t frames, unsigned channels,
                      double progressStart, double progressStep);
}
