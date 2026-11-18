#include "smartmix/SmartMix.hpp"
#include <cassert>
#include <cmath>
#include <iostream>
#include <vector>
int main() {
  using namespace smartmix;
  constexpr double sr=44100; constexpr std::size_t frames=static_cast<std::size_t>(sr*24);
  std::vector<float> audio(frames);
  // 120 BPM pulse train with a short decaying click every half-second.
  for(std::size_t i=0;i<frames;++i) {
    double t=i/sr, phase=std::fmod(t,0.5);
    audio[i]=phase<0.012 ? static_cast<float>(0.7*std::exp(-phase*350.0)*std::sin(2*3.141592653589793*1200*t)) : 0.0f;
  }
  auto a=analyze({audio.data(),audio.size(),1,sr});
  assert(a.usable && a.rms>0 && a.peak<=1.0);
  assert(a.bpm>0 && std::abs(a.bpm-120.0)<4.0);
  std::vector<float> left(256,1.0f),right(256,1.0f),out(256);
  renderEqualPower(left.data(),right.data(),out.data(),256,1,0,1.0/255.0);
  assert(std::abs(out.front()-1.0f)<1e-5);
  assert(std::abs(out.back()-1.0f)<1e-5);
  for(float x:out) assert(std::isfinite(x));
  Track x; x.analysis=a; x.energy=0.6; x.outroSeconds=8;
  Track y; y.analysis=a; y.energy=0.55;
  auto p=planTransition(x,y);
  assert(p.valid && p.durationSeconds>=8 && p.durationSeconds<=24);
  std::cout<<"SmartMix DSP tests passed; estimated BPM="<<a.bpm<<" confidence="<<a.beatConfidence<<"\n";
}
