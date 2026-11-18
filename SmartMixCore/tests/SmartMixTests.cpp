#include <algorithm>
#include "smartmix/SmartMix.hpp"
#include "smartmix/SmartMixBridge.h"
#include <cassert>
#include <cmath>
#include <iostream>
#include <limits>
#include <vector>
int main(){using namespace smartmix;constexpr double sr=44100;constexpr std::size_t n=static_cast<std::size_t>(sr*32);std::vector<float> audio(n);
for(std::size_t i=0;i<n;++i){double t=i/sr,phase=std::fmod(t,0.5);audio[i]=phase<0.012?static_cast<float>(0.7*std::exp(-phase*350)*std::sin(2*3.141592653589793*1200*t)):0;}
auto a=analyze({audio.data(),audio.size(),1,sr});assert(a.usable&&a.rms>0&&a.peak<=1&&a.bpm>0);assert(std::abs(a.bpm-120)<4);assert(a.firstBeatSeconds>=0&&a.firstBeatSeconds<1);
StreamingAnalyzer stream(sr,16.0);
const std::size_t chunkFrames=static_cast<std::size_t>(sr*4);
for(std::size_t offset=0;offset<n;offset+=chunkFrames){
 const std::size_t count=std::min(chunkFrames,n-offset);
 assert(stream.append({audio.data()+offset,count,1,sr}));
}
auto streamed=stream.analyzeLatest();
assert(streamed.usable&&std::abs(streamed.bpm-120)<4);
assert(std::abs(streamed.durationSeconds-32.0)<0.01);
assert(std::abs(stream.observedSeconds()-32.0)<0.01);
assert(!stream.append({audio.data(),128,1,48000}));
const double beforeMalformed=stream.observedSeconds();
float malformed[4]={0.1f,0.2f,std::numeric_limits<float>::quiet_NaN(),0.4f};
assert(!stream.append({malformed,4,1,sr}));
assert(std::abs(stream.observedSeconds()-beforeMalformed)<1e-12);

// Exercise the stable C ABI used by Objective-C++/runtime adapters.
SMAnalysis cAnalysis{};
assert(SMAnalyzePCM(audio.data(),audio.size(),1,sr,&cAnalysis)==1);
assert(std::abs(cAnalysis.bpm-a.bpm)<1e-9);
SMTrack cx{}; cx.analysis=cAnalysis; cx.energy=.6; cx.outroSeconds=8;
SMTrack cy{}; cy.analysis=cAnalysis; cy.energy=.55;
SMPlan cPlan{};
assert(SMPlanTransition(&cx,&cy,1.08,8,&cPlan)==1);
assert(cPlan.valid && cPlan.durationSeconds>0);
void *cStream=SMCreateStreamingAnalyzer(sr,16.0);
assert(cStream!=nullptr);
assert(SMAppendPCM(cStream,audio.data(),chunkFrames,1,sr)==1);
SMAnalysis cStreamAnalysis{};
assert(SMAnalyzeLatest(cStream,&cStreamAnalysis)==0 || cStreamAnalysis.durationSeconds>0);
assert(SMObservedSeconds(cStream)>0);
SMDestroyStreamingAnalyzer(cStream);

std::vector<float> l(256,1),r(256,1),o(256);renderEqualPower(l.data(),r.data(),o.data(),256,1,0,1.0/255);assert(std::abs(o.front()-1)<1e-5&&std::abs(o.back()-1)<1e-5);for(float x:o)assert(std::isfinite(x));
Track x;x.analysis=a;x.energy=.6;x.outroSeconds=8;Track y;y.analysis=a;y.energy=.55;auto p=planTransition(x,y);assert(p.valid&&p.durationSeconds>0&&p.incomingPlaybackRate==1);
Track edge=x;edge.analysis.durationSeconds=31.9;
auto edgePlan=planTransition(edge,y);
assert(edgePlan.valid);
assert(edgePlan.startOutgoingSeconds+edgePlan.durationSeconds<=edge.analysis.durationSeconds-edge.outroSeconds+1e-6);

double op=(p.startOutgoingSeconds-a.firstBeatSeconds)/a.beatPeriodSeconds,ip=(p.startIncomingSeconds-a.firstBeatSeconds)/a.beatPeriodSeconds;assert(std::abs(op-std::round(op))<1e-6&&std::abs(ip-std::round(ip))<1e-6);assert(!planTransition(x,y,1,8).valid);assert(!planTransition(x,y,1.08,0).valid);
std::cout<<"SmartMix DSP tests passed; BPM="<<a.bpm<<" confidence="<<a.beatConfidence<<"\n";}
