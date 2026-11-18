# Implementation status

## Implemented and CI-verified
- Portable C++17 library with no network or media-acquisition code.
- PCM validation, duration, RMS and peak measurement.
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
- No Taurus runtime integration has been made; two-deck source access and scheduling remain unproven.

## Next engineering gates
1. Add multi-band spectral flux, tempo candidates and half/double-time resolution.
2. Add downbeat and phrase confidence; don't label a first beat as a downbeat.
3. Add silence/intro/outro and energy-section analysis with annotated licensed fixtures.
4. Add a high-quality tempo-preserving time-stretch/resampler and test pitch preservation.
5. Add a render callback that consumes two independently clocked decks through a bounded, lock-free handoff; test underruns and format changes.
6. Inspect Taurus playback integration points on-device. Only use PCM the player legitimately exposes and never fetch substitute audio.
7. Validate on actual supported iOS versions and devices before calling the integration complete.

A passing CI run validates compilation and the synthetic DSP tests only. It does not validate audio quality or the Taurus/Spotify adapter.
