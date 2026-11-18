#pragma once
#include <stdint.h>
#ifdef __cplusplus
extern "C" {
#endif

typedef struct SMAnalysis {
    double bpm;
    double beatPeriodSeconds;
    double firstBeatSeconds;
    double beatConfidence;
    double rms;
    double peak;
    double durationSeconds;
    int usable;
} SMAnalysis;

typedef struct SMTrack {
    SMAnalysis analysis;
    double introSeconds;
    double outroSeconds;
    double energy;
    int vocalsLikely;
} SMTrack;

typedef struct SMPlan {
    int valid;
    double startOutgoingSeconds;
    double startIncomingSeconds;
    double durationSeconds;
    double tempoRatio;
    double incomingPlaybackRate;
    double score;
    unsigned bars;
    char reason[96];
} SMPlan;

// All functions are local and deterministic. PCM must be decoded audio the host
// legitimately exposes. Analysis and planning must run off the real-time callback.
int SMAnalyzePCM(const float *samples, uint64_t frames, unsigned channels,
                 double sampleRate, SMAnalysis *result);
void *SMCreateStreamingAnalyzer(double sampleRate, double windowSeconds);
int SMAppendPCM(void *analyzer, const float *samples, uint64_t frames,
                unsigned channels, double sampleRate);
int SMAnalyzeLatest(void *analyzer, SMAnalysis *result);
double SMObservedSeconds(void *analyzer);
void SMDestroyStreamingAnalyzer(void *analyzer);
int SMPlanTransition(const SMTrack *outgoing, const SMTrack *incoming,
                     double maxTempoRatio, unsigned bars, SMPlan *result);
void SMRenderEqualPower(const float *outgoing, const float *incoming,
                        float *output, uint64_t frames, unsigned channels,
                        double progressStart, double progressStep);

#ifdef __cplusplus
}
#endif
