#pragma once
#include <cstddef>
#include <cstdint>
#include <vector>
namespace smartmix {
struct AudioView { const float* samples{}; std::size_t frames{}; unsigned channels{1}; double sampleRate{44100.0}; };
struct Analysis { double bpm{0}; double beatPeriodSeconds{0}; double firstBeatSeconds{0}; double beatConfidence{0}; double rms{0}; double peak{0}; double durationSeconds{0}; bool usable{false}; };
struct Track { Analysis analysis; double introSeconds{0}; double outroSeconds{0}; double energy{0}; bool vocalsLikely{false}; double firstDownbeatSeconds{0}; unsigned beatsPerBar{0}; };
struct Plan { bool valid{false}; double startOutgoingSeconds{0}; double startIncomingSeconds{0}; double durationSeconds{0}; double tempoRatio{1}; double incomingPlaybackRate{1}; double score{0}; unsigned bars{0}; unsigned beatsPerBar{4}; const char* reason{"not evaluated"}; };
Analysis analyze(const AudioView& audio);

// Feed decoded PCM from a non-real-time worker/tap. append() performs no allocation
// after construction. analyzeLatest() allocates a snapshot and must NOT run on the
// audio render callback. Calls must be serialized on one worker thread.
class StreamingAnalyzer {
public:
    explicit StreamingAnalyzer(double sampleRate=44100.0, double windowSeconds=32.0);
    bool append(const AudioView& chunk);
    Analysis analyzeLatest() const;
    double observedSeconds() const;
private:
    double sampleRate_{0};
    std::vector<float> ring_;
    std::size_t writeIndex_{0};
    std::size_t framesStored_{0};
    std::uint64_t framesSeen_{0};
};
Plan planTransition(const Track& outgoing,const Track& incoming,double maxTempoRatio=1.08,unsigned bars=8);
void renderEqualPower(const float* outgoing,const float* incoming,float* output,std::size_t frames,unsigned channels,double progressStart,double progressStep);
}
