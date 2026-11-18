#include "smartmix/SmartMixBridge.h"
#include "smartmix/SmartMix.hpp"
#include <algorithm>
#include <cstdio>
#include <cstring>
#include <new>

namespace {
smartmix::Analysis fromC(const SMAnalysis &a) {
    smartmix::Analysis out;
    out.bpm=a.bpm; out.beatPeriodSeconds=a.beatPeriodSeconds;
    out.firstBeatSeconds=a.firstBeatSeconds; out.beatConfidence=a.beatConfidence;
    out.rms=a.rms; out.peak=a.peak; out.durationSeconds=a.durationSeconds;
    out.usable=a.usable!=0;
    return out;
}
void toC(const smartmix::Analysis &a, SMAnalysis *out) {
    out->bpm=a.bpm; out->beatPeriodSeconds=a.beatPeriodSeconds;
    out->firstBeatSeconds=a.firstBeatSeconds; out->beatConfidence=a.beatConfidence;
    out->rms=a.rms; out->peak=a.peak; out->durationSeconds=a.durationSeconds;
    out->usable=a.usable?1:0;
}
smartmix::Track fromC(const SMTrack &t) {
    smartmix::Track out;
    out.analysis=fromC(t.analysis); out.introSeconds=t.introSeconds;
    out.outroSeconds=t.outroSeconds; out.energy=t.energy;
    out.vocalsLikely=t.vocalsLikely!=0;
    out.firstDownbeatSeconds=t.firstDownbeatSeconds;
    out.beatsPerBar=t.beatsPerBar;
    return out;
}
}

extern "C" int SMAnalyzePCM(const float *samples, uint64_t frames,
                              unsigned channels, double sampleRate,
                              SMAnalysis *result) {
    if (!result || frames > static_cast<uint64_t>(SIZE_MAX)) return 0;
    try {
        const auto a=smartmix::analyze({samples,static_cast<std::size_t>(frames),channels,sampleRate});
        toC(a,result);
        return a.usable?1:0;
    } catch (...) { return 0; }
}

extern "C" void *SMCreateStreamingAnalyzer(double sampleRate,double windowSeconds) {
    try { return new smartmix::StreamingAnalyzer(sampleRate,windowSeconds); }
    catch (...) { return nullptr; }
}
extern "C" int SMAppendPCM(void *handle,const float *samples,uint64_t frames,
                              unsigned channels,double sampleRate) {
    if (!handle || frames > static_cast<uint64_t>(SIZE_MAX)) return 0;
    try {
        return static_cast<smartmix::StreamingAnalyzer *>(handle)->append(
            {samples,static_cast<std::size_t>(frames),channels,sampleRate})?1:0;
    } catch (...) { return 0; }
}
extern "C" int SMAnalyzeLatest(void *handle,SMAnalysis *result) {
    if (!handle || !result) return 0;
    try {
        const auto a=static_cast<smartmix::StreamingAnalyzer *>(handle)->analyzeLatest();
        toC(a,result);
        return a.usable?1:0;
    } catch (...) { return 0; }
}
extern "C" double SMObservedSeconds(void *handle) {
    return handle?static_cast<smartmix::StreamingAnalyzer *>(handle)->observedSeconds():0.0;
}
extern "C" void SMDestroyStreamingAnalyzer(void *handle) {
    delete static_cast<smartmix::StreamingAnalyzer *>(handle);
}
extern "C" int SMPlanTransition(const SMTrack *outgoing,const SMTrack *incoming,
                                  double maxTempoRatio,unsigned bars,SMPlan *result) {
    if (!outgoing || !incoming || !result) return 0;
    try {
        const auto p=smartmix::planTransition(fromC(*outgoing),fromC(*incoming),maxTempoRatio,bars);
        result->valid=p.valid?1:0; result->startOutgoingSeconds=p.startOutgoingSeconds;
        result->startIncomingSeconds=p.startIncomingSeconds; result->durationSeconds=p.durationSeconds;
        result->tempoRatio=p.tempoRatio; result->incomingPlaybackRate=p.incomingPlaybackRate;
        result->score=p.score; result->bars=p.bars;
        result->beatsPerBar=p.beatsPerBar;
        std::snprintf(result->reason,sizeof(result->reason),"%s",p.reason?p.reason:"unknown");
        return p.valid?1:0;
    } catch (...) { return 0; }
}
extern "C" void SMRenderEqualPower(const float *outgoing,const float *incoming,
                                     float *output,uint64_t frames,unsigned channels,
                                     double progressStart,double progressStep) {
    if (frames > static_cast<uint64_t>(SIZE_MAX)) return;
    smartmix::renderEqualPower(outgoing,incoming,output,static_cast<std::size_t>(frames),
                               channels,progressStart,progressStep);
}
