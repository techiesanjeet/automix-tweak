# Implementation status

## Target device
- Primary validation target: iPhone 16 Pro running iOS 27.2.1. This is a test target, not a minimum deployment target.
- Theos deployment target remains iOS 14.0 until compatibility is measured.

## Latest build-preparation changes

- Added a macOS 15 / Theos arm64 build workflow that installs Theos + iOS SDKs, compiles the dylib, verifies its architecture, and uploads the artifact.
- Removed the old `AudioUnitRender` fade-only hook from the active engine. That hook only attenuated the current song, used unsynchronized shared state, and was not a real two-track AutoMix transition.
- The current UI is an honest status/diagnostic surface. It reports that playback integration is pending and does not alter Taurus audio.
- The default-branch diagnostic snapshot completed a successful Theos arm64 build and artifact upload. The feature branch's spectral-flux DSP, prepared-PCM substitution slot, and sinc varispeed resampler completed a successful Theos arm64 build at commit `5d1fabb`. The later Core ML runtime adapter and compiled model resource-bundle packaging are awaiting their first successful end-to-end Theos build.
- This is still a safe diagnostic build target, **not a functioning AutoMix release**. The runtime source contract remains unverified.

## Implemented and CI-verified
- Portable C++17 library with no network or media-acquisition code, compiled into the Theos dylib target.
- Stable C ABI (`SmartMixBridge.h`) for PCM analysis, streaming analysis, planning, and equal-power rendering.
- Streaming append validates a complete chunk before mutating the rolling buffer.
- PCM validation, duration, RMS and peak measurement.
- Bounded rolling-window PCM ingestion; chunk append is allocation-free after setup.
- 2048-point Hann-windowed spectral-flux onset curve at approximately 100 frames/second, followed by normalized autocorrelation (nominal 60–180 BPM range).
- Conservative half-time alias handling and folded beat-phase estimate in the fallback analyzer.
- Beat This small0 Core ML conversion verified against upstream PyTorch, plus native C++ log-mel parity against torchaudio (max absolute error `1.91e-5`, mean `1.76e-6`).
- Beat/downbeat peak postprocessing, conservative 3/4 or 4/4 meter inference, and a C bridge that applies the model grid to planner tracks.
- Synthetic 120 BPM and 100 BPM fixtures, including stereo downmix coverage.
- Phrase-length overlap calculation, beat-phase fallback, and model-derived downbeat/meter-aware phrase alignment.
- Equal-power two-buffer gain rendering.
- Worker-side 32-tap windowed-sinc sample-rate conversion and varispeed; this changes pitch and is not pitch-preserving time stretch.
- Local Beat This log-mel preprocessing, beat/downbeat logit postprocessing, and conservative 3/4 or 4/4 meter inference.
- Beta 0.60.7 source processor callback ABI is inferred from ARM64 disassembly; the non-invasive runtime probe reports source format and read-ahead capability without registering a processor.
- Objective-C++ Core ML adapter loads the compiled model locally, accepts mono 22050 Hz chunks through the native spectrogram frontend, and passes beat/downbeat logits through the C bridge into meter-aware planning.
- Planner can align both transition ends to model-derived downbeats when both tracks have reliable, matching meter; it falls back to beat-phase alignment otherwise and skips known meter mismatches.
- Fixed-capacity `PreparedPCMSubstitution` slot: worker-side preparation, lock-free state publication, exact source-epoch/frame scheduling, bounded callback memcpy, deterministic original-stream rejoin, and cancellation on discontinuity.
- Tests for 120/100 BPM, stereo downmix, playback-rate-aware incoming buffer bounds, malformed metadata, native Beat This frontend output, beat/downbeat postprocessing and meter inference, C bridge track updates, resampler frequency/varispeed, prepared PCM boundary crossing, exact rejoin, late start, epoch mismatch, and cancellation.

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
- The spectral-flux fallback remains heuristic. Beat This provides beat/downbeat logits, but meter inference is conservative and does not yet detect keys, sections, vocal density, or phrase-one semantics.
- Key, sections, vocal density, stems, and intro/outro detection are not implemented.
- `incomingPlaybackRate` is consumed by the varispeed resampler, which shifts pitch; pitch-preserving time stretch is not implemented.
- The renderer expects two already-decoded, resampled PCM inputs in the same format. `PreparedPCMSubstitution` can substitute a pre-rendered buffer at an explicit host source-frame interval, but it is not connected to Taurus and cannot obtain incoming PCM by itself.
- Streaming snapshot analysis allocates and must stay on a serialized background worker, never the real-time callback.
- No Taurus runtime source-processor adapter has been implemented or device-tested.

## Next engineering gates
1. Establish the exact Beta source-processor contract: callback signature, source lifetime, buffer ownership, frame clock, format, read-ahead semantics, and cancellation behavior.
2. Verify whether Taurus exposes the next queued track's decoded PCM through its normal streaming path early enough to render a transition locally. Do not fetch substitute audio or use Alpha's YouTube acquisition path.
3. Implement a Beta-specific adapter that captures bounded PCM off the real-time callback, pre-renders the transition, inserts it at a verified source-clock position, and rejoins the original stream at an exact frame boundary. Always retain a deterministic passthrough fallback.
4. Finish the Theos resource-bundle build, then benchmark the bundled Core ML model on iPhone 16 Pro / iOS 27.2.1. Model export and upstream parity are already verified in CI; no playback-time cloud inference or model download is permitted.
5. Improve beat/downbeat, section, intro/outro and energy analysis; add a pitch-preserving time-stretch/resampler.
6. Test seeks, queue changes, interruptions, route changes, format changes, underruns, memory, thermal behavior and battery on the target device.

A passing CI run validates compilation and synthetic DSP tests only. Static IPA analysis is not a runtime/device test. Do not claim the Taurus integration is complete until the Beta source contract and handoff have been verified on-device.
