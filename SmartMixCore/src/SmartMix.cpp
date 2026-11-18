#include "smartmix/SmartMix.hpp"
#include <algorithm>
#include <cmath>
#include <vector>
namespace smartmix {
namespace {
constexpr double kPi=3.14159265358979323846;
float monoAt(const AudioView& a,std::size_t f) { double s=0; for(unsigned c=0;c<a.channels;++c)s+=a.samples[f*a.channels+c]; return static_cast<float>(s/a.channels); }
double alignAtOrAfter(double t,double phase,double period) { if(!(period>0)||!std::isfinite(t)||!std::isfinite(phase))return t; return phase+std::ceil((t-phase)/period)*period; }
}
Analysis analyze(const AudioView& a) {
 Analysis out;
 if(!a.samples||a.frames<2||!a.channels||a.channels>8||!std::isfinite(a.sampleRate)||a.sampleRate<8000||a.sampleRate>192000)return out;
 out.durationSeconds=static_cast<double>(a.frames)/a.sampleRate; double sum=0; float peak=0;
 for(std::size_t i=0;i<a.frames;++i){float x=monoAt(a,i);if(!std::isfinite(x))return Analysis{};sum+=double(x)*x;peak=std::max(peak,std::abs(x));}
 out.rms=std::sqrt(sum/a.frames);out.peak=peak;
 if(out.durationSeconds<8){out.usable=out.rms>1e-5;return out;}
 const std::size_t hop=std::max<std::size_t>(1,static_cast<std::size_t>(a.sampleRate/100));
 std::vector<float> env;env.reserve(a.frames/hop);double previous=0;
 for(std::size_t base=0;base+hop<=a.frames;base+=hop){double e=0;for(std::size_t j=0;j<hop;++j){double x=monoAt(a,base+j);e+=x*x;}double level=std::sqrt(e/hop);env.push_back(static_cast<float>(std::max(0.0,level-previous)));previous=level;}
 if(env.size()<400){out.usable=out.rms>1e-5;return out;}
 const int minLag=static_cast<int>(6000.0/180.0),maxLag=static_cast<int>(6000.0/60.0);
 double best=-1,second=-1;int bestLag=0;
 for(int lag=minLag;lag<=maxLag&&lag<static_cast<int>(env.size()/2);++lag){double xy=0,xx=0,yy=0;for(std::size_t i=lag;i<env.size();++i){double x=env[i],y=env[i-lag];xy+=x*y;xx+=x*x;yy+=y*y;}double corr=(xx>1e-12&&yy>1e-12)?xy/std::sqrt(xx*yy):0;if(corr>best){second=best;best=corr;bestLag=lag;}else if(corr>second)second=corr;}
 if(bestLag>0&&best>0.05){out.bpm=6000.0/bestLag;out.beatPeriodSeconds=60.0/out.bpm;out.beatConfidence=std::clamp(best*0.75+(best-std::max(0.0,second))*0.25,0.0,1.0);std::size_t n=std::min<std::size_t>(bestLag,env.size());auto it=std::max_element(env.begin(),env.begin()+n);out.firstBeatSeconds=std::distance(env.begin(),it)/100.0;}
 out.usable=out.rms>1e-5&&out.durationSeconds>8;return out;
}
Plan planTransition(const Track& a,const Track& b,double maxRatio,unsigned bars){
 Plan p;p.bars=bars;
 if(!std::isfinite(maxRatio)||maxRatio<=1||bars<1||bars>16){p.reason="invalid planner policy";return p;}
 if(!a.analysis.usable||!b.analysis.usable){p.reason="audio analysis unavailable";return p;}
 if(a.analysis.bpm<=0||b.analysis.bpm<=0||a.analysis.beatConfidence<0.08||b.analysis.beatConfidence<0.08||a.analysis.beatPeriodSeconds<=0||b.analysis.beatPeriodSeconds<=0){p.reason="beat grid confidence too low";return p;}
 double ratio=b.analysis.bpm/a.analysis.bpm;if(ratio<1.0/maxRatio||ratio>maxRatio){p.reason="tempo mismatch exceeds policy";return p;}
 p.tempoRatio=ratio;p.incomingPlaybackRate=1.0/ratio;
 const double ob=a.analysis.beatPeriodSeconds,ib=b.analysis.beatPeriodSeconds;p.durationSeconds=ob*4.0*bars;
 double latest=a.analysis.durationSeconds-std::max(0.0,a.outroSeconds)-p.durationSeconds,earliest=std::max(0.0,a.introSeconds);
 if(latest<earliest){p.reason="outgoing track has no full phrase available";return p;}
 p.startOutgoingSeconds=alignAtOrAfter(std::max(earliest,latest),a.analysis.firstBeatSeconds,ob);
 p.startIncomingSeconds=alignAtOrAfter(std::max(0.0,b.introSeconds),b.analysis.firstBeatSeconds,ib);
 if(p.startOutgoingSeconds+p.durationSeconds>a.analysis.durationSeconds-std::max(0.0,a.outroSeconds)+1e-6||p.startIncomingSeconds+p.durationSeconds>b.analysis.durationSeconds){p.reason="not enough prepared audio";return p;}
 double ts=1.0-std::abs(std::log(ratio))/std::log(maxRatio),es=1.0-std::min(1.0,std::abs(a.energy-b.energy));p.score=std::clamp(0.65*ts+0.35*es,0.0,1.0);p.valid=true;p.reason="beat-phase-aligned phrase candidate";return p;
}
void renderEqualPower(const float* a,const float* b,float* out,std::size_t frames,unsigned channels,double start,double step){
 if(!a||!b||!out||!channels||!std::isfinite(start)||!std::isfinite(step))return;
 for(std::size_t f=0;f<frames;++f){double t=std::clamp(start+step*static_cast<double>(f),0.0,1.0);float ga=static_cast<float>(std::cos(t*kPi/2)),gb=static_cast<float>(std::sin(t*kPi/2));for(unsigned c=0;c<channels;++c)out[f*channels+c]=a[f*channels+c]*ga+b[f*channels+c]*gb;}
}
}
