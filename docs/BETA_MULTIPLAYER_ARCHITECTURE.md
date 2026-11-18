# Beta native multi-player architecture: static evidence

## Scope and confidence

This note records static findings from the supplied Taurus 0.60.7 Beta and 0.60.5 Alpha IPAs. It does not execute Spotify code and does not establish that private player APIs can be safely called or hooked at runtime.

## A useful Alpha/Beta control

The main `Payload/Spotify.app/Spotify` executable in the Alpha and Beta IPAs is byte-for-byte identical:

- SHA-256: `ad1704ad613b27c12cc3e8a0da5f58c6ccf3c4f5c7ebf64b2982c67358c7f6cb`
- arm64 Mach-O executable
- `LC_ENCRYPTION_INFO_64` reports `cryptid 0` in both packages.

The injected `Frameworks/spotifyglass.dylib` differs between Alpha and Beta. This means the native Spotify player architecture described below is shared by both builds; Alpha's additional AutoMix behavior is in the injected dylib layer, not a different main executable.

## Native player-pool types recovered from Swift reflection metadata

The unencrypted main executable contains Swift type descriptors and field metadata for these concrete types:

- `MultiPlayerImpl`
- `InternalAudioCoordinator`
- `InternalPlayerFactoryImpl`
- `InternalPlayerImpl`
- `GenericPlayerPool`
- `SinglePlayerImpl`
- `PlayerGroupImpl`
- `MultiPlayerSessionImpl`
- `MixingTransitionPlayerImpl`
- `MixingTransitionPlayerServiceImpl`

The following property names and relationships are present in the type field metadata:

### MultiPlayerImpl and its internal player factory

`MultiPlayerImpl` has stored properties named:

- `playerPool`
- `internalPlayerFactory`
- `surfaceManagerFactory`
- `delegatingSurfaceManager`
- `sharedSurfaceManager`
- `currentContext`
- shared mute-controller/state fields.

`InternalPlayerFactoryImpl` has dependencies including:

- `playbackRequestFactory`
- `audioSessionActivationHandler`
- `unmutedHandleProvider`
- `videoPlayerFactory` / `videoSurfaceManager`
- playback-observer and reporting-context factories.

`InternalPlayerImpl` holds a `BMBetamaxPlayer` reference plus `audioCoordinator`, `audioTap`, playback-request and observer factories, reporting context, and playback state. This is evidence that the multipayer subsystem owns real player objects and audio-coordination/tap objects, not merely UI state.

### GenericPlayerPool and player holders

`GenericPlayerPool` has fields named:

- `limit`
- `freeCount`
- `builder`
- `onStop`
- `reservedInstances`
- `holders`
- `activeContext`

`SinglePlayerImpl` has a `playerHolder`, `disposables`, `isInvalidated`, `wasPlayingWhileActive`, and `inUse` state.

`PlayerGroupImpl` includes `scope`, `activeSubject`, `muteState`, `stopOnDeactivate`, and lifecycle/release-related fields such as `instance`, `owningContext`, `onRelease`, and `onStop`.

`MultiPlayerSessionImpl` also retains a `playerPool`, `muteController`, `lastPlayerGroup`, and `playerLimit`.

These names make the pool/factory path a strong candidate for investigating a second Taurus-native player. They do **not** prove the pool allows two simultaneous audible music players; the limit, acquisition policy, player-group lifecycle, audio-session arbitration, and actual audio-tap semantics still need to be recovered.

### Native mixing-transition player

A separate `MixingTransitionPlayerImpl` type has fields named:

- `player` (type metadata identifies `SPTPlayer`)
- `contextURI`
- `wasPlayingNonTransitionContext`
- `playingTransitionContext`
- `playGeneration`
- error state and `_playerService`.

A corresponding `MixingTransitionPlayerServiceImpl` retains an `SPTPlayerService` and view/controller state. This appears to be a distinct native transition-preview/player service. Its exact role in actual song playback and whether it can be reused for arbitrary incoming-track streaming have not yet been established.

## Native playlist AutoMix transition schema and service path (new)

The same executable contains a richer playlist-mixing subsystem:

- `MixingCoreAutomixTrackPair` stores `outURL`, `inURL`, `itemSpeedA`, and `itemSpeedB`.
- `MixingCoreAutomixTransitionResult` distinguishes a transition result from `notSupported`, `emptyTransitions`, and `loaderUnavailable`.
- `MixingCoreAutomixTransitionLoader` stores an `automixClient`, a transition result, outgoing/incoming track row IDs, `outStartPosition`, `outSpeed`, `inStartPosition`, and `inSpeed`.
- `MixingAutomixTransitionLoader` composes an `automixClient` with the core transition loader.
- `MixingPlayingTransitionContext` contains `trackA`, `trackB`, `outgoing`, `incoming`, and preview/context state.
- `MixingTransitionWithRowIDs` contains a transition plus outgoing/incoming row IDs and fields including `beats`, `duration`, and `bpm`.
- `MixingTransition` distinguishes `auto`, `custom`, and `noTransition` variants and stores overlap/preset information.

The executable also contains the generated `Spotify_Automix_Esperanto_Proto_AutomixClient` type and request/response messages including `GetComputedTransitionsRequest/Response`, `AdjustTransitionRecipeForItemSpeedsRequest/Response`, and `GetMaxTransitionLengthResponse`. This strongly suggests the built-in transition recipe/computation path depends on an Esperanto service client. It is not evidence of a local-only planner, and the current implementation must not rely on those requests for local analysis or transition decisions.

This schema is still useful as a description of what the native player expects conceptually: a specific outgoing/incoming track pair, positions, speed ratios, and transition duration/beat metadata. It may guide a future local planner adapter, but the exact player method contract and whether the transition player can consume locally constructed data remain unknown. Do not fabricate calls into the private service or bypass its validation based on field names.

## Interpretation for AutoMix

This is a more promising avenue than trying to take over Sing's one global source-processor slot:

1. Taurus/Spotify already has an internal player factory and a generic player pool.
2. Player instances carry audio coordinator and audio-tap dependencies.
3. There is also a native mixing-transition player type with its own `SPTPlayer` field.
4. The playlist-mixing subsystem models outgoing/incoming track pairs and transition positions/speeds.
5. Alpha and Beta share the exact same main executable, so this native architecture is available in both versions.

However, reflection field metadata only proves that these types and stored properties exist. It does not establish that:
- a second player can be acquired while the current music player is active;
- both players can emit audible PCM concurrently on one output clock;
- the audio tap exposes decoded PCM rather than metadata or rendered output;
- a next-track player can be prepared using Taurus's normal online streaming pipeline without changing the user's queue/session;
- the native transition player accepts locally constructed parameters rather than service-generated transition data;
- Alpha's AutoMix engine uses this native pool (its inspected path still contains a separate download/provider route);
- private Swift methods can be safely invoked from a tweak.

Do not call private methods or mutate pool state based on property names alone.

## Next reverse-engineering targets

1. Recover the Swift method/vtable metadata and implementations for `InternalPlayerFactoryImpl`, `GenericPlayerPool`, `SinglePlayerImpl`, `PlayerGroupImpl`, and `InternalPlayerImpl`.
2. Determine the concrete acquisition/release policy and actual `limit` value at runtime.
3. Trace how `audioTap` is created, what data it receives, and whether it is a decoded-PCM tap with a stable source clock.
4. Trace `MixingTransitionPlayerImpl` and `SPTPlayerService` to establish whether they use a second player for transition preview only or can participate in ordinary queue playback.
5. Trace the `AutomixClient` RPC call sites and determine whether a local transition recipe can be passed to the native playback layer without contacting that service.
6. Only after those facts are established, design a Taurus-native incoming-track adapter. Keep all model inference and transition planning local. Keep Taurus's normal streaming path as the only source of song audio. If the incoming stream cannot be prepared safely, skip the mix and preserve normal playback.

## Safety boundary

No code in the current AutoMix diagnostic package acquires a player from this pool, calls these private methods, changes queue state, or alters playback. The current diagnostic package remains passthrough-only. No device validation has been performed on iPhone 16 Pro / iOS 27.2.1.
