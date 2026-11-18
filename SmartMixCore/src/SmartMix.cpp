#include "smartmix/SmartMix.hpp"
#include <algorithm>
#include <cmath>
#include <limits>

namespace smartmix {
namespace {
constexpr double kPi = 3.14159265358979323846;
float monoAt(const AudioView& a, std::size_t f) {
  if (!a.samples || !a.channels || f >= a.frames) return 0.0f;
  double s=0; for(unsigned c=0;c<a.channels;++c) s+=a.samples[f*a.channels+c];
  return static_cast<float>(s/a.channels);
}
}
Analysis analyze(const AudioView& a) {
  Analysis out;
  if (!a.samples || a.frames < 2 || !a.channels || a.sampleRate < 8000 || a.sampleRate > 192000) return out;
  out.durationSeconds = a.frames/a.sampleRate;
  double sum=0; float peak=0;
  for(std::size_t i=0;i<a.frames;++i) { float x=monoAt(a,i); sum+=double(x)*x; peak=std::max(peak,std::abs(x)); }
  out.rms=std::sqrt(sum/a.frames); out.peak=peak;
  // Build a 100 Hz positive-difference energy envelope. This is deliberately
  // lightweight and deterministic; it is not a neural source separator.
  const std::size_t hop=static_cast<std::size_t>(a.sampleRate/100.0);
  if(hop==0 || out.durationSeconds<8.0) { out.usable=out.rms>1e-5; return out; }
  std::vector<float> env; env.reserve(a.frames/hop);
  double previous=0;
  for(std::size_t base=0;base+hop<=a.frames;base+=hop) {
    double e=0; for(std::size_t j=0;j<hop;++j) { double x=monoAt(a,base+j); e+=x*x; }
    double rms=std::sqrt(e/hop); env.push_back(static_cast<float>(std::max(0.0,rms-previous))); previous=rms;
  }
  if(env.size()<400) { out.usable=out.rms>1e-5; return out; }
  const int minLag=static_cast<int>(6000.0/180.0); // 180 BPM
  const int maxLag=static_cast<int>(6000.0/60.0);  // 60 BPM
  double best=-1, second=-1; int bestLag=0;
  for(int lag=minLag;lag<=maxLag && lag<static_cast<int>(env.size()/2);++lag) {
    double xy=0,xx=0,yy=0;
    for(std::size_t i=lag;i<env.size();++i) { double x=env[i],y=env[i-lag]; xy+=x*y; xx+=x*x; yy+=y*y; }
    double corr=(xx>1e-12 && yy>1e-12)?xy/std::sqrt(xx*yy):0;
    if(corr>best) { second=best; best=corr; bestLag=lag; } else if(corr>second) second=corr;
  }
  if(bestLag) {
    out.bpm=6000.0/bestLag; out.beatPeriodSeconds=60.0/out.bpm;
    out.beatConfidence=std::clamp((best-std::max(0.0,second))*2.5,0.0,1.0);
    // Refine phase by choosing the strongest onset in the first estimated beat.
    std::size_t search=std::min<std::size_t>(bestLag,env.size());
    auto it=std::max_element(env.begin(),env.begin()+search);
    out.firstBeatSeconds=std::distance(env.begin(),it)/100.0;
  }
  out.usable=out.rms>1e-5 && out.durationSeconds>8.0;
  return out;
}
Plan planTransition(const Track& a,const Track& b,double maxRatio,unsigned bars) {
  Plan p; p.bars=bars;
  if(!a.analysis.usable || !b.analysis.usable) { p.reason="audio analysis unavailable"; return p; }
  if(a.analysis.bpm<=0 || b.analysis.bpm<=0 || a.analysis.beatConfidence<0.08 || b.analysis.beatConfidence<0.08) { p.reason="beat grid confidence too low"; return p; }
  double ratio=b.analysis.bpm/a.analysis.bpm;
  if(ratio<1.0/maxRatio || ratio>maxRatio) { p.reason="tempo mismatch exceeds policy"; return p; }
  p.tempoRatio=ratio;
  double beat=a.analysis.beatPeriodSeconds;
  p.durationSeconds=std::clamp(beat*4.0*std::max(1u,bars),8.0,24.0);
  p.startOutgoingSeconds=std::max(a.introSeconds,a.analysis.durationSeconds-a.outroSeconds-p.durationSeconds);
  // Align incoming start to its next beat, never to a negative offset.
  double ib=b.analysis.beatPeriodSeconds;
  p.startIncomingSeconds=std::ceil(std::max(0.0,b.introSeconds)/ib)*ib;
  if(p.startOutgoingSeconds<0 || p.startIncomingSeconds+p.durationSeconds>b.analysis.durationSeconds) { p.reason="not enough prepared audio"; return p; }
  double tempoScore=1.0-std::abs(std::log(ratio))/std::log(maxRatio);
  double energyScore=1.0-std::min(1.0,std::abs(a.energy-b.energy));
  p.score=std::clamp(0.65*tempoScore+0.35*energyScore,0.0,1.0);
  p.valid=true; p.reason="beat-aligned candidate"; return p;
}
void renderEqualPower(const float* a,const float* b,float* out,std::size_t frames,unsigned channels,double start,double step) {
  if(!a || !b || !out || !channels) return;
  for(std::size_t f=0;f<frames;++f) {
    double t=std::clamp(start+step*f,0.0,1.0);
    float ga=static_cast<float>(std::cos(t*kPi/2.0));
    float gb=static_cast<float>(std::sin(t*kPi/2.0));
    for(unsigned c=0;c<channels;++c) out[f*channels+c]=a[f*channels+c]*ga+b[f*channels+c]*gb;
  }
}
}
