# Offline core: first implementation

This directory is a platform-neutral C++17 DSP prototype. It intentionally has no networking, filesystem access, model downloads, or media acquisition.

## API
- `analyze(AudioView)`: computes duration, RMS/peak, a 100 Hz positive-difference energy envelope, a normalized autocorrelation BPM estimate, and a coarse first-beat estimate.
- `planTransition(Track, Track)`: rejects unusable/low-confidence beat grids and unsafe tempo ratios; otherwise proposes a bounded phrase-length overlap and beat-aligned incoming start.
- `renderEqualPower(...)`: renders two already-decoded, sample-aligned interleaved float buffers using equal-power gains.

## Current limitations (important)
This is a foundation, not Apple Music parity. The onset estimator is intentionally small and currently does not provide robust downbeat, musical-key, vocal, section, or stem analysis. BPM can be ambiguous at half/double time. The planner's intro/outro and energy values are supplied by the adapter/caller; it does not infer them yet. The renderer assumes both inputs have already been resampled, tempo-aligned, and synchronised to the same output clock. It does not decode Spotify streams or create a second player.

Do not connect this renderer to a live playback hook until the host adapter can guarantee two independent PCM sources, scheduling, cancellation, and output-format handling. If the host cannot provide those capabilities from audio already available locally, report the limitation rather than downloading substitute tracks.

## Build and test
```sh
cmake -S . -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build --parallel
ctest --test-dir build --output-on-failure
```

The CI workflow runs the deterministic synthetic pulse/BPM and crossfade tests. Add only licensed or self-generated PCM fixtures.
