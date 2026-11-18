# Implementation status

## Target device\n- Primary validation target: iPhone 16 Pro running iOS 27.2.1. This is a test target, not a minimum deployment target. Theos currently remains at iOS 14.0 until runtime compatibility is measured.\n\n## Implemented and CI-verified
- Portable C++17 library with no network or media-acquisition code.
- PCM validation, duration, RMS and peak measurement.
- Bounded rolling-window PCM ingestion for streaming playback: chunk append is allocation-free after setup, while snapshots/analysis are restricted to a serialized background worker.
- Lightweight 100 Hz energy-onset envelope and autocorrelation BPM estimate (nominal 60–180 BPM range).
- Coarse first-onset phase estimate.
- Transition candidate validation against beat confidence and a configurable tempo-ratio bound.
- Phrase-length overlap calculation and start-point alignment to each track's estimated beat phase.
- Equal-power two-buffer gain rendering.
- Synthetic 120 BPM fixture and endpoint/phase/policy assertions.
- GitHub Actions build and CTest workflow.

## Known limitations
This is a DSP prototype, not an Apple Music AutoMix replacement yet:
- BPM estimates can be ambiguous at half/double tempo; confidence is only a heuristic.
- The onset envelope is broadband RMS change, not a production spectral-flux beat tracker.
- First-beat phase is not a downbeat detector; bar-one / phrase-one remains unknown.
- Key, sections, vocal density, stems, and intro/outro detection are not implemented.
- `incomingPlaybackRate` is a plan value only. No time-stretch engine is implemented.
- Renderer expects two already-decoded, resampled, synchronised PCM buffers in the same format. It is not a Spotify decoder or dual-player.
- The streaming analyzer is a rolling PCM prototype, not yet a low-memory multi-feature streaming model; its snapshot analysis allocates and must stay off the real-time callback.
- No Taurus runtime integration has been made; two-deck source access and scheduling remain unproven.

## Next engineering gates
1. Convert the official Beat This! small0 checkpoint to a locally bundled Core ML runtime, verify prediction parity against upstream, and retain the C++ fallback. Benchmark inference and memory on the iPhone 16 Pro / iOS 27.2.1. See docs/LOCAL_MODEL.md.
2. Add multi-band spectral flux, tempo candidates and half/double-time resolution, and benchmark rolling analysis CPU/memory on-device.
3. Add silence/intro/outro and energy-section analysis with annotated licensed fixtures.
4. Add a high-quality tempo-preserving time-stretch/resampler and test pitch preservation.
5. Add a render callback that consumes two independently clocked decks through a bounded, lock-free handoff; test underruns and format changes.
6. Inspect Taurus playback integration points on-device. Only use PCM the player legitimately exposes and never fetch substitute audio.
7. Validate on actual supported iOS versions and devices before calling the integration complete.

A passing CI run validates compilation and the synthetic DSP tests only. It does not validate audio quality or the Taurus/Spotify adapter.
