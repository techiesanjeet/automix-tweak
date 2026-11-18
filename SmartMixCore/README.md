# Offline SmartMix core

This directory is a platform-neutral C++17 DSP and prepared-audio prototype. It has no networking, filesystem access, model downloads, or media acquisition.

## Components

- `analyze(AudioView)`: computes duration, RMS/peak, a Hann-windowed 2048-point spectral-flux onset curve, normalized autocorrelation tempo, and a folded beat-phase estimate.
- `StreamingAnalyzer`: bounded rolling PCM capture for one serialized background worker. Appends do not allocate after construction; snapshot analysis allocates and must not run on the audio callback.
- `planTransition(Track, Track)`: validates analysis/metadata, tempo ratio, phrase duration, beat phase, outgoing outro bounds, and incoming source consumption after playback-rate adjustment.
- `renderEqualPower(...)`: renders two already-decoded, same-format interleaved float buffers with equal-power gains.
- `PreparedPCMSubstitution`: fixed-capacity, lock-free-state handoff for a fully rendered PCM transition. The worker copies and arms the buffer against a source epoch and exact source-frame interval. The audio thread only copies prepared frames into an output buffer already filled with original PCM; it allocates nothing, takes no mutex, and rejoins the original stream automatically after the final prepared frame. Seek/skip/format/epoch discontinuities cancel the slot.

## Integration boundary

`PreparedPCMSubstitution` is host-neutral. It is **not** connected to Taurus's private source processor because the supplied Beta binary's callback ABI, buffer ownership, source clock, next-track PCM availability, and processor lifecycle are still unverified. Do not wire it to guessed private prototypes. If the host cannot provide incoming decoded PCM from its normal streaming path early enough, leave playback untouched.

The callback contract is strict:
- one real-time callback thread owns `process()`;
- output is prefilled with original-source PCM;
- interleaved Float32 format, channel count, sample rate, source epoch and monotonically increasing source frame are explicit;
- the prepared buffer remains owned by the slot until the audio thread acknowledges completion/cancellation;
- the slot is reused only after `Completed` or `Cancelled`;
- a late start or frame-clock discontinuity cancels rather than attempting a phase-shifted transition.

## Current limitations

This is not Apple Music AutoMix parity. Beat phase is not downbeat/measure detection; BPM can be ambiguous at half/double time. Key, sections, vocal density, stems, and automatic intro/outro inference are not implemented. `incomingPlaybackRate` is planner metadata only; no pitch-preserving time-stretch engine exists. The renderer assumes both inputs have already been decoded, resampled, and tempo-aligned. No Taurus PCM capture or live source-processor adapter exists yet.

## Build and test

```sh
cmake -S . -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build --parallel
ctest --test-dir build --output-on-failure
```

CI covers synthetic 120/100 BPM fixtures, stereo downmix, planner bounds/metadata validation, equal-power rendering, prepared-buffer scheduling, exact rejoin, and cancellation. Add only licensed or self-generated PCM fixtures.
