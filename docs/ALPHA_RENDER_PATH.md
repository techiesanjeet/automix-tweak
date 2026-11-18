# Alpha AutoMix render and insertion path

## Finding

The Alpha 60.5 build does **not** provide evidence of two independently playing Spotify player decks. Its visible native path is better described as **offline transition rendering followed by insertion into the live Spotify audio source**.

This distinction matters: it can produce a seamless audible transition without asking two player nodes to run concurrently during the audible blend. The transition is rendered ahead of time into PCM, then the audio pipeline substitutes that prepared PCM over a bounded interval while the ordinary player continues.

## Evidence from Alpha binary

The Alpha `spotifyglass.dylib` exports:

- `SGAutoMixEnginePrepare`
- `SGAutoMixEnginePrepareIncoming`
- `SGAutoMixEngineRender`
- `SGAutoMixAudioBegin`, `SGAutoMixAudioArm`, `SGAutoMixAudioCopy`, `SGAutoMixAudioEnd`
- Staging/progress APIs: `SGAutoMixAudioStageBegin`, `SGAutoMixAudioStageCopy`, `SGAutoMixAudioStageCommit`, `SGAutoMixAudioWritten`, `SGAutoMixAudioPlayed`, `SGAutoMixAudioMixProgress`

It also references `AVAudioEngine`, `AVAudioFile`, `AVAudioPlayerNode`, and `AVAudioUnitTimePitch`, plus `NativeAutoMixRenderer`, `StereoPCM`, and `SGPreparedPCM`. These are consistent with an AVFoundation-based render/preparation path. The presence of these classes alone would not prove live dual-deck playback.

The Alpha call path invokes `SGAutoMixEnginePrepare` and `SGAutoMixEnginePrepareIncoming`, then invokes `SGAutoMixEngineRender` to produce the transition output. The resulting PCM is passed into `SGAutoMixAudioArm`.

The Alpha audio insertion layer installs a source processor through `SGAudioPipelineSetSourceProcessor`. Its state tracks written and played frame positions, supports staging/copying the two output channels, and exposes progress/starvation/drain state. The Alpha log strings explicitly describe the mix as replacing Spotify's audio from a source-clock point and rejoining it later, while Spotify playback continues and is advanced ahead by the transition duration. This is strong evidence for pre-rendered PCM substitution rather than two independently audible live player decks.

## Incoming audio acquisition in Alpha

The Alpha binary contains an external acquisition path using YouTube Music search/player resolution, downloading, cache, and transcoding. Its log strings describe rendering from two cached audio files and matching the outgoing prepared audio against the live Spotify audio. That acquisition path is **not suitable** for this project and must not be used.

### File-oriented PrepareIncoming entry point (confirmed)

Further disassembly of Alpha's exported `SGAutoMixEnginePrepareIncoming` confirms that its native entry point is file-oriented: the Swift ABI signature takes four C-string path arguments and a floating-point parameter, and the function converts those C strings into Foundation `URL.fileURLWithPath` values before starting the preparation worker. It does not take a Spotify player object, track queue object, AudioBufferList, or incoming source handle.

This reinforces the distinction between Alpha's renderer and the required Taurus streaming adapter. Alpha can prepare and render PCM once its source files are available, but this entry point does not show how to obtain the next song from Taurus's normal online stream. The external download/provider path is therefore not a solution to the incoming-PCM problem.

## Required project architecture

The user's required architecture is different:

1. Taurus streams both tracks through its normal playback/queue path.
2. The tweak receives only decoded PCM that Taurus legitimately exposes from its own audio pipeline.
3. A local worker analyzes the outgoing PCM and the next-track PCM; local model inference and transition planning happen on-device.
4. The transition is pre-rendered to PCM locally.
5. The audio source processor inserts the prepared PCM at the planned source-clock interval, then rejoins the ordinary Taurus stream.
6. If the incoming Taurus stream is not ready, or source timing/read-ahead cannot be established safely, skip the transition and let Taurus play normally.

No YouTube Music lookup/download, duplicate track download, cloud model, or audio upload is part of this design.

## Beta 60.7 comparison

The Beta binary does **not** export the Alpha `SGAutoMixEnginePrepare/PrepareIncoming/Render` or `SGAutoMixAudio*` AutoMix layer, and it does not show the same `AVAudioPlayerNode` / `AVAudioUnitTimePitch` references.

However, Beta does contain the lower-level audio-pipeline substrate:

- `SGAudioPipelineAvailable`
- `SGAudioPipelineTapped`
- `SGAudioPipelineSetSourceProcessor`
- `SGAudioPipelinePull` and `SGAudioPipelinePullOriginal`
- `SGAudioPipelineSourceFormat`
- `SGAudioPipelineSourcePrefix`
- `SGAudioPipelineSourceAheadFrames`
- `SGAudioPipelineSourceCanReadAhead`
- `SGAudioPipelineRegister`

This is a meaningful discovery. It suggests the Beta build retains a source-processing and read-ahead integration surface that can be investigated for a Taurus-native PCM path. It does **not** by itself prove that the next track's decoded PCM is available before the transition, or that two track sources can be scheduled independently. The source queue semantics, lifetime, format, and timing still need to be established.

## Engineering consequence

Do not transplant Alpha's dylib or copy its external-download pipeline. Instead, implement a small Beta-specific adapter around the Beta audio-pipeline surface:

- Discover/validate the active source and format without changing playback.
- Determine whether the queued next track has a separate registered source and whether its decoded PCM can be read ahead through supported pipeline APIs.
- Capture bounded PCM windows off the real-time callback; never block or allocate in the callback.
- Render the transition locally and atomically publish the ready PCM.
- Use the source processor only for deterministic, precomputed frame substitution; keep a passthrough path for every failure.
- Track source-clock frame counts and discontinuities; cancel on seek, route change, interruption, source replacement, or queue changes.
- Never advance the source clock by an assumed amount. Validate the exact handoff and rejoin frame positions.

### Confidence

- **High confidence:** Alpha has an offline prepare/render pipeline and a source-processor PCM insertion layer.
- **High confidence:** Alpha's exported PrepareIncoming interface is based on local file paths, not a native next-player/PCM handle.
- **High confidence:** Beta has the lower-level source processor and read-ahead-related APIs but lacks Alpha's AutoMix engine/arm layer.
- **Not yet proven:** Beta exposes the next queued song as a separate decoded PCM source early enough to build the incoming transition without any duplicate download.
- **Not yet proven:** seamless source-clock rejoin under real playback, seek, interruption, and route changes on iPhone 16 Pro / iOS 27.2.1.

This is static binary analysis of the supplied arm64 IPA files, not a runtime/device test.
