# Beta prepared-track and native transition path

## Scope

This note records static ARM64 disassembly and reflection findings from the supplied Taurus 0.60.7 Beta. The main Spotify executable is byte-for-byte identical to the one in Taurus 0.60.5 Alpha (SHA-256 `ad1704ad613b27c12cc3e8a0da5f58c6ccf3c4f5c7ebf64b2982c67358c7f6cb`). The findings therefore apply to both supplied builds. No private method has been called at runtime.

## Prepared-track lifecycle found in the main executable

The main executable contains these log strings and associated code paths:

| Function / log | ARM64 address | Static interpretation |
|---|---:|---|
| Prepare playback of track | `0x10110A8F0` | Builds a prepare command from track information, playback/parent-playback identity, and a start position; stores a prepared-track object on the player |
| Discard prepared track | `0x101D18460` | Checks the prepared-track field and sends a discard operation before clearing it |
| Open prepared track | `0x104712A68` | Reads the prepared-track object and submits an open-prepared command to the internal track-player path |
| Transition to prepared track | `0x101CAC53C` | Constructs transition state for the prepared track and calls the pending-track playback path |
| playPendingTrack | `0x107FD2490` | Handles the pending-track playback operation and associated player state |
| Open track player | `0x10129E5D8` | Receives the prepared track and transition-related parameters and opens the track-player path |

The player object used by these methods has adjacent fields at offsets `0x780` and `0x788` in the inspected build. The open/discard paths read the prepared-track field at `this + 0x788`; the open path also reads the current-track field at `this + 0x780`. The prepare path creates/retains the prepared-track object. These are private, version-specific offsets and must not be used as a production ABI without runtime validation.

The executable also contains a “peeking on the next track” log path. This supports the conclusion that the native player has a distinct prepared-next-track lifecycle rather than relying only on a UI queue entry.

**What this establishes:** Taurus/Spotify has a native way to prepare an upcoming track through its ordinary player/streaming system, then open, discard, or transition to it. This is a promising way to ensure the incoming track comes from Taurus's normal online stream rather than a duplicate download.

**What it does not establish:** the prepared track's decoded PCM is exposed to a third-party callback before it is opened, or that the private prepared-track object can safely be read or retained by AutoMix.

## Native transition metadata read when opening the prepared track

The `Open prepared track` path reads metadata from the current-track object and looks up these keys:

- `automix.auto_transition_recipe`
- `automix.auto_preset_id`
- `automix.backend_arm_id`
- `automix.transition_uri`

The recipe, preset, backend arm, and transition URI are copied/parsed into the internal transition/open parameters before the prepared track is opened. The main executable also contains related metadata/configuration names including:

- `automix.fade_in_transition_uri`
- `automix.fade_out_transition_uri`
- `outStartPosition`, `inStartPosition`
- `outSpeed`, `inSpeed`
- `outMinStartPosition`, `outMaxStartPosition`
- `inMinStartPosition`, `inMaxStartPosition`
- `outItemSpeed`, `inItemSpeed`
- `barDurationToInSpeed`
- `auto_transition_beatmatchability_threshold_permil`
- `auto_transition_downbeat_confidence_threshold`
- `auto_transition_speed_automation_delta_permil`
- `auto_transition_speed_automation_offset_ms`
- `auto_transition_speed_automation_step_ms`

These names show that the native player understands an outgoing/incoming recipe with start positions and speed automation. They do not, by themselves, reveal the full serialized recipe schema or prove that the player accepts a locally constructed recipe.

## Why the stock AutoMix planner is not the local solution

Swift reflection metadata identifies `MixingCoreAutomixTransitionLoader` and `MixingAutomixTransitionLoader` with an `automixClient` dependency. The executable contains a generated `Spotify_Automix_Esperanto_Proto_AutomixClient` type and request/response messages such as `GetComputedTransitionsRequest/Response` and `AdjustTransitionRecipeForItemSpeedsRequest/Response`.

This is strong evidence that the stock transition-recipe computation path is service-client-backed. The current project must not depend on those requests for analysis or transition decisions. The field names and recipe shape are useful reverse-engineering references only.

A possible future design is to keep the prepared-track lifecycle (normal Taurus streaming) but generate the recipe locally from Beat This and local DSP, then pass it through a verified native transition interface. That remains a hypothesis until the recipe format, optional fields, transition URI requirements, and player validation rules are recovered.

## Beta source-queue exports do not provide PCM

The Beta `spotifyglass.dylib` source-queue helpers were also inspected:

- `SGAudioSourceQueueInitialize` scans the main image's Mach-O layout and records build-specific source-queue metadata.
- `SGAudioSourceQueueSupported` accepts a very specific queue address/layout and checks a magic value.
- `SGAudioSourceQueuePrefix` uses guarded `vm_read_overwrite` calls to inspect queue metadata, validates nested object signatures, and accumulates frame/byte-count-like values. It returns a prefix/frame count; it does not copy or return sample data.
- `SGAudioSourceQueueFrames` is a thin wrapper over the prefix query.
- `SGAudioPipelineSourceCanReadAhead` scans registered queue entries and reports whether a supported queue is present. It does not identify an incoming track or return decoded PCM.
- `SGAudioPipelineSourcePrefix(context, ...)` selects queue metadata associated with a specific source context.

This surface can help establish queue readiness and frame counts, but it is not a decoded-PCM API. The queue layout is private and build-specific.

## SpotifyAudioProbe cross-check

The IPA also contains `SpotifyAudioProbe.dylib`, whose strings mention `pcm_bytes`, `sample_buffer_calls`, and `player_buffer_calls`. The actual inspected implementations do not expose a usable PCM source:

- `SAPReadSourceGraph` clears its output buffer and sets only a version field.
- `SAPWithObservedAudioKey` returns immediately.
- `SAPObservedAudioKeyCount` returns zero.
- `SpotifyAudioProbeInitialize`, `SpotifyAudioProbeSetObserver`, and `SpotifyAudioProbeMuteForSeconds` are stubs in this binary.

Do not treat those strings as evidence of a working decoded-PCM tap or integrate that library as an audio provider.

## Current conclusion

The prepared-track lifecycle is the strongest new lead for satisfying the user's requirement that Taurus continue streaming both songs normally. The stock player can prepare, open, discard, and transition to an upcoming track. The stock Automix recipe path appears to rely on a generated service client, so it cannot be used unchanged for local-only planning.

Still unresolved:

1. Whether the prepared track's decoded PCM can be observed before the handoff, without changing or duplicating the stream.
2. Whether the source-queue internals contain a stable, safe way to copy prepared-track PCM, or only frame-count metadata.
3. The exact serialized `automix.auto_transition_recipe` schema and whether a locally generated recipe can be accepted without a remote `transition_uri`.
4. Whether the native transition engine can be invoked without the service-backed recipe loader.
5. The exact source clock and safe rejoin point for the prepared-track transition.

Do not read or retain private prepared-track pointers, replace the global source-processor slot, or construct metadata based on these offsets in the production tweak yet. The next safe step is read-only runtime observation on the exact Beta build, followed by a verified adapter contract. If the incoming stream cannot be prepared and analyzed safely, AutoMix must skip the mix and allow normal Taurus playback to continue.

## User constraints

- Keep Taurus's normal online streaming as the only source of song audio.
- Keep analysis, model inference, planning, and any local recipe generation on-device.
- Do not use Alpha's YouTube Music/download-provider path.
- Do not duplicate-download the incoming song or upload audio/features to a cloud model.
- Preserve normal playback if preparation or transition validation fails.

No runtime validation has been performed on iPhone 16 Pro / iOS 27.2.1.
