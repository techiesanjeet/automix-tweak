# SmartMix design and Alpha-build findings

## Goal
Apple Music AutoMix-style transitions while Taurus streams tracks normally. Song delivery may use the streaming service's network; audio analysis, feature extraction, transition planning, and rendering decisions run locally on-device. No audio, features, or transition requests are sent to an AutoMix server. Spotify/Taurus is an adapter, not a dependency of the core.

## Alpha IPA observations
The supplied Taurus 0.60.5 Alpha binary contains a substantially expanded spotifyglass.dylib compared with the supplied 0.60.7 Beta. Binary strings/type names include SGAutoMixEnginePrepare, SGAutoMixEnginePrepareIncoming, SGAutoMixEngineRender, SGPreparedPCM, SGAutoMixAudio staging/progress hooks, NativeAutoMixRenderer, StereoPCM, HTDemucsSeparator, StemDSP, and a model-cache type. This is evidence of a native two-track preparation/render pipeline and a local stem-separation component in Alpha; it is not proof that every code path is active or that the model weights ship in the IPA.

In the supplied 0.60.7 Beta, the same framework has AutoMix settings/transition metadata strings and SGPreparedPCM/SGPCMDecodeCancellation names, but the Alpha engine entry points (Prepare, PrepareIncoming, Render), model lifecycle, AVAudioPlayerNode, and AVAudioUnitTimePitch symbols were not present in the string/symbol scan. This suggests Beta does not contain Alpha's complete native engine surface; it is not merely a disabled preference. Do not transplant Alpha's compiled dylib blindly across builds because private ABI and host internals may differ.\n\nThe same Alpha binary exposes model lifecycle symbols (download, path, progress, cancel, remove) and external-download/provider types including YTClient and SGAutoMixDownloadProvider. It also references YouTube Music search/download operations to obtain incoming audio in at least one preparation path. No obvious standalone model-weight file was found in either supplied IPA under common model extensions. These are binary-level observations, not proof that every code path runs in every playback scenario.

**Conclusion:** Alpha is a useful reference for a full transition pipeline, but it is not a drop-in solution for a strict offline requirement. The new core must avoid those external acquisition paths and only analyze audio already legitimately available to the player or user. If the next track's PCM cannot be prepared locally, the adapter must report that limitation rather than fetch substitute audio.

## Streaming playback with on-device intelligence

Online song delivery and local AutoMix are compatible. The intended data path is:

1. Taurus streams and buffers the current track through its normal playback service.
2. A narrowly scoped adapter observes decoded PCM that the player legitimately exposes. It copies bounded chunks to a background analysis worker; the real-time render callback must not run FFTs, allocate memory, wait on locks, or perform model inference.
3. The worker maintains a rolling PCM/feature window and updates tempo, beat phase, loudness, section and vocal-density estimates as evidence becomes available.
4. When the queue identifies the next track, Taurus prepares that track through its own normal streaming path. The engine analyzes its available preview/lookahead PCM locally.
5. A local planner chooses transition entry/exit points and effects. A local renderer pre-renders the overlap from outgoing and incoming PCM, then a verified Taurus source processor substitutes that prepared PCM over an exact source-frame interval and rejoins the original stream.
6. If Taurus cannot expose incoming decoded PCM early enough, or source-clock insertion/rejoin cannot be guaranteed, cancel the planned mix and let Taurus's normal playback behavior continue.

The engine must never download a duplicate song from another service. Streaming the song from Taurus is allowed; sending audio/features to a cloud model or requesting a cloud-computed transition is not part of this design. A future compact ML model should be bundled/installed locally and have deterministic DSP fallback behavior.

### Real-time and buffer ownership rules

- Capture only from a documented or otherwise legitimate player PCM tap; do not bypass DRM or extract protected media.
- The audio render callback only consumes precomputed transition parameters and ready PCM. Analysis runs on a worker queue.
- Use bounded buffers, explicit sample formats, sample-rate conversion before mixing, and a shared render clock.
- Track IDs/source epochs invalidate stale analysis after seek, skip, queue replacement, interruption, or track change.
- Never block the audio callback waiting for network data, a model, a mutex, or an incoming deck.
- The current StreamingAnalyzer accepts PCM chunks on one serialized non-real-time worker and keeps a bounded rolling window. analyzeLatest() allocates a snapshot, so it is explicitly not a render-callback API.

## Current implementation state

The active `AutoMixEngine.mm` is deliberately playback-neutral. It installs only a diagnostic status surface and does not hook AudioUnit rendering, capture decoded PCM, or modify playback. The portable C++ core is linked into the dylib through a stable C ABI.

The analyzer now computes a Hann-windowed, 2048-point spectral-flux curve at approximately 100 frames/second and estimates tempo with normalized autocorrelation. It folds the onset curve over the estimated beat period to produce a beat-phase candidate. This is a stronger onset signal than broadband RMS deltas, but it remains a lightweight DSP heuristic: it does not identify downbeats, musical bars, sections, keys, or vocal overlap.

The planner validates tempo ratio, phrase duration, beat phase, source bounds and incoming source consumption after playback-rate adjustment. The renderer mixes two already-decoded, same-format PCM buffers with equal-power gains. A host-neutral `PreparedPCMSubstitution` slot holds a pre-rendered transition in fixed-capacity storage and copies it only over an exact source-epoch/frame interval. It performs no callback allocation or mutex wait, rejoins original PCM after the final prepared frame, and cancels on a late start or source discontinuity. It is still not connected to Taurus: the Beta callback ABI and next-track PCM path remain unknown. Streaming analysis allocates its snapshot and must stay on a serialized worker.

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
1. **Prove the audio path:** establish whether Taurus's normal queue/streaming path exposes continuous next-track decoded PCM early enough for local pre-rendering, and verify the source-processor frame clock and rejoin semantics. Do not bypass protected media decoding.
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
