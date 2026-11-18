# Implementation status

## Target device
- Primary validation target: iPhone 16 Pro running iOS 27.2.1. This is a test target, not a minimum deployment target.
- Theos deployment target remains iOS 14.0 until compatibility is measured.

## Latest build-preparation changes

- Added a macOS 15 / Theos arm64 build workflow that installs Theos + iOS SDKs, compiles the dylib, verifies its architecture, and uploads the artifact.
- Removed the old `AudioUnitRender` fade-only hook from the active engine. That hook only attenuated the current song, used unsynchronized shared state, and was not a real two-track AutoMix transition.
- The current UI is now an honest status/diagnostic surface. It explicitly reports that playback integration is pending and does not alter Taurus audio.
- This is a safe diagnostic build target, **not yet a functioning AutoMix release**. The Theos workflow has been committed but no successful iOS build artifact has yet been observed. The branch still needs a CI run and the runtime source contract remains unverified.

## Implemented and CI-verified
- Portable C++17 library with no network or media-acquisition code, compiled into the Theos dylib target.
- Stable C ABI (`SmartMixBridge.h`) for PCM analysis, streaming analysis, planning, and equal-power rendering.
- Streaming append validates a complete chunk before mutating the rolling buffer.
- PCM validation, duration, RMS and peak measurement.
- Bounded rolling-window PCM ingestion; chunk append is allocation-free after setup.
- Lightweight 100 Hz energy-onset envelope and autocorrelation BPM estimate (nominal 60–180 BPM range).
- Coarse first-onset phase estimate and transition candidate validation.
- Phrase-length overlap calculation and beat-phase alignment.
- Equal-power two-buffer gain rendering.
- Synthetic 120 BPM fixtures and CMake/CTest CI coverage.

## Alpha/Beta architecture finding
Static analysis of the supplied Alpha 60.5 and Beta 60.7 binaries is documented in `docs/ALPHA_RENDER_PATH.md`.

- Alpha's audible transition is best evidenced as pre-rendered PCM substitution into the live source pipeline, not two independently audible live player decks.
- Alpha prepares outgoing and incoming audio, renders transition PCM, arms a source processor, then rejoins ordinary playback.
- Alpha also contains an external YouTube Music acquisition/cache path. That path is explicitly excluded from this project.
- Beta lacks Alpha's high-level AutoMix prepare/render/arm exports, but retains lower-level source-processor and read-ahead-related symbols (`SGAudioPipelineSetSourceProcessor`, `SGAudioPipelinePull`, `SGAudioPipelinePullOriginal`, `SGAudioPipelineSourceAheadFrames`, `SGAudioPipelineSourceCanReadAhead`, etc.).
- These Beta symbols are promising integration leads, not proof that next-track decoded PCM is available early enough or that source-clock rejoin is safe.

## Known limitations
This remains a DSP prototype, not an Apple Music AutoMix replacement:
- BPM can be ambiguous at half/double tempo; confidence is heuristic.
- The onset envelope is broadband RMS change, not production spectral flux.
- First-onset phase is not a downbeat or phrase-one detector.
- Key, sections, vocal density, stems, and intro/outro detection are not implemented.
- `incomingPlaybackRate` is a plan value only; no time-stretch engine is implemented.
- The renderer expects two already-decoded, resampled PCM inputs in the same format. It is not a decoder, source scheduler, or Taurus integration.
- Streaming snapshot analysis allocates and must stay on a serialized background worker, never the real-time callback.
- No Taurus runtime source-processor adapter has been implemented or device-tested.

## Next engineering gates
1. Establish the exact Beta source-processor contract: callback signature, source lifetime, buffer ownership, frame clock, format, read-ahead semantics, and cancellation behavior.
2. Verify whether Taurus exposes the next queued track's decoded PCM through its normal streaming path early enough to render a transition locally. Do not fetch substitute audio or use Alpha's YouTube acquisition path.
3. Implement a Beta-specific adapter that captures bounded PCM off the real-time callback, pre-renders the transition, inserts it at a verified source-clock position, and rejoins the original stream at an exact frame boundary. Always retain a deterministic passthrough fallback.
4. Export the pinned official Beat This! small0 checkpoint, verify parity with upstream, then evaluate a bundled Core ML model on iPhone 16 Pro / iOS 27.2.1. No playback-time cloud inference or model download.
5. Improve beat/downbeat, section, intro/outro and energy analysis; add a pitch-preserving time-stretch/resampler.
6. Test seeks, queue changes, interruptions, route changes, format changes, underruns, memory, thermal behavior and battery on the target device.

A passing CI run validates compilation and synthetic DSP tests only. Static IPA analysis is not a runtime/device test. Do not claim the Taurus integration is complete until the Beta source contract and handoff have been verified on-device.
