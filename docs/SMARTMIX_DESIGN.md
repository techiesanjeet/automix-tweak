# SmartMix design and Alpha-build findings

## Goal
Apple Music AutoMix-style transitions, with all analysis and transition decisions performed locally. Spotify/Taurus is an optional adapter, not a dependency of the core.

## Alpha IPA observations
The supplied Taurus 0.60.5 Alpha binary contains a substantially expanded spotifyglass.dylib compared with the supplied 0.60.7 Beta. Its strings/type names indicate a native AutoMix renderer, outgoing/incoming preparation, local caching, audio separation, transition rendering, bar/beat-based transition lengths, FIFO/read-ahead diagnostics, and playback-clock rejoin.

The same Alpha binary also contains strings describing a separately downloaded AutoMix model and YouTube Music search/download operations to obtain incoming audio in at least one preparation path. These are binary-level observations, not proof that every code path runs in every playback scenario. No obvious standalone model asset was found inside the IPA under common model names/extensions.

**Conclusion:** Alpha is a useful reference for a full transition pipeline, but it is not a drop-in solution for a strict offline requirement. The new core must avoid those external acquisition paths and only analyze audio already legitimately available to the player or user. If the next track's PCM cannot be prepared locally, the adapter must report that limitation rather than fetch substitute audio.

## Current repository code review

### AutoMixEngine.mm
The hook calls the original AudioUnitRender and applies a time-varying gain to its output. It does not render or sum a second source. It can create a fade/dip curve, but not a genuine two-track transition.

Risks to fix:
- shared UI/audio-thread state lacks a complete synchronization strategy;
- output format is assumed to be Float32 and cached against one AudioUnit;
- per-sample trigonometric gain is unnecessary real-time work;
- preview modulates the current song rather than rendering an outgoing/incoming pair.

### AutoMixV2/AutoMixEngineV2.mm
V2 makes the two-deck requirement explicit and applies complementary equal-power gains. However, it does not create the second deck or prove that the host can render two tracks simultaneously. Its shared frame counter assumes callbacks from the two decks behave in a way that must be validated; callbacks may not arrive in lockstep.

Treat V2 as a DSP experiment, not proof of a usable Spotify dual-deck API.

## Proposed architecture

    SmartMixCore/
      Audio/       PCMBuffer, AudioFormat
      Analysis/    RMSLoudness, OnsetAndBeatGrid, BPMEstimator,
                   DownbeatEstimator, KeyEstimator, SectionFeatures
      Planning/    TrackFeatures, TransitionCandidate, TransitionScorer,
                   BeatAlignment, TempoPolicy
      Rendering/   EqualPowerCrossfade, BassSwap, EQAutomation,
                   TransitionRenderer
      Cache/       AnalysisCache
      Tests/       licensed PCM fixtures and deterministic tests

    Adapters/
      SpotifyTaurus/
      StandalonePlayer/

Start with deterministic DSP, not a large opaque model. A compact optional on-device model may later classify sections or vocal density, but inference must remain local and have a non-network fallback.

## Milestones
1. **Prove the audio path:** establish whether the host exposes two independently renderable sources and whether the next track can be prepared without network access. Do not bypass protected media decoding.
2. **Build an analysis harness:** use licensed/local PCM fixtures to test BPM, beat grid, downbeats, loudness, silence, and intro/outro detection.
3. **Build a planner:** score exit/entry points using beat phase, tempo ratio, phrase boundaries, energy, and vocal overlap.
4. **Build a two-source renderer:** beat-aligned timing, equal-power gain curves, optional low-frequency handoff, bounded CPU/memory.
5. **Integrate narrowly:** the Spotify/Taurus adapter supplies buffers, timing, and scheduling; analysis and planning remain network-independent.
6. **Validate on device:** interruptions, seek/skip, route changes, backgrounding, format changes, and late preparation.

## Planning rules
Reject or shorten a candidate when beat confidence is low, tempo ratio is unsafe, phrase boundaries do not align, vocals overlap heavily, incoming audio is not ready, or the host cannot guarantee two-source playback. A single-source fade is not a successful Automix transition.

## Tests
- beat-grid error against annotated fixtures;
- BPM tolerance and half/double-time ambiguity;
- no clipping, NaNs, or buffer-boundary discontinuities;
- loudness continuity and deterministic output;
- CPU/memory ceilings on target iPhones;
- automated proof that core analysis/planning makes zero network requests.

## Packaging boundary
Do not commit decrypted IPAs, Spotify executables, proprietary frameworks, extracted proprietary model weights, or copied proprietary implementation code. Keep notes high-level and implement independently. Use licensed test audio.
