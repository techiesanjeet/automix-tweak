# Beta source-processor integration contract

## Purpose
Define the evidence required before implementing a Beta-specific PCM substitution adapter. This document intentionally does not declare private function prototypes or call undocumented functions based only on symbol names.

## Static evidence available
The supplied Taurus 0.60.7 Beta binary contains these source-pipeline names:

- SGAudioPipelineAvailable
- SGAudioPipelineTapped
- SGAudioPipelineSetSourceProcessor
- SGAudioPipelinePull
- SGAudioPipelinePullOriginal
- SGAudioPipelineSourceFormat
- SGAudioPipelineSourcePrefix
- SGAudioPipelineSourceAheadFrames
- SGAudioPipelineSourceCanReadAhead
- SGAudioPipelineRegister

These names suggest a source processor with original-source pull and read-ahead concepts. They do not establish exact signatures, calling convention, ownership, lifetime, threading, or whether read-ahead means next-track audio versus additional frames from the current source.

## Required contract (must be measured, not guessed)

| Contract item | Evidence required | Safe implementation rule |
|---|---|---|
| Registration | Exact symbol/class owner, parameter and return types, registration/unregistration lifecycle | Do not register until exact ABI and lifecycle are confirmed |
| Processor callback | Exact callback prototype, invocation order, thread and reentrancy | Callback must be bounded, nonblocking and allocation-free |
| Source identity | How a source is identified and replaced | Bind captured PCM to a source epoch; invalidate on replacement |
| PCM format | Sample type, interleaving, channels, sample rate, layout and frame count | Reject unsupported formats; never reinterpret unknown buffers |
| Buffer ownership | Who allocates, owns, retains and releases input/output memory | Copy only into preallocated bounded storage; never retain borrowed pointers |
| Pull semantics | Whether Pull invokes the original source, and how PullOriginal differs | Preserve exactly-once original pull semantics; no recursive pull |
| Read-ahead | Meaning and limits of SourceAheadFrames / SourceCanReadAhead | Do not infer next-track availability from current-source lookahead |
| Clock | Frame counter domain, reset conditions, timestamp relation and discontinuity handling | Schedule insertion only against a verified source-frame clock |
| Processor chaining | Ordering relative to existing processors and behavior when one declines | Preserve other processors; deterministic passthrough on decline |
| Cancellation | Seek, skip, queue change, interruption, route/format change and teardown | Atomically cancel prepared output and return to original source |
| Rejoin | Exact original-source frame at which ordinary PCM resumes | Verify continuity at the sample boundary before enabling fades |

## Required runtime experiments

1. Read-only discovery: enumerate the Beta runtime owner class/image and exact method/type metadata where exposed.
2. Registration lifecycle: establish when the host registers and unregisters processors; do not install a competing processor during discovery.
3. Format probe: record actual PCM format and callback frame sizes without retaining audio or changing samples.
4. Pull probe: determine whether the processor receives a source callback, a completed output buffer, or a pull-through request. Record call order and thread identity.
5. Read-ahead probe: establish whether read-ahead returns more frames from the current track or exposes a queued next track. Track source identity and timestamps; metadata alone is insufficient.
6. Clock probe: compare callback frame counts with host playback time across buffer-size changes, seeks and track changes.
7. Passthrough proof: a no-op processor must produce bit-identical or appropriately format-identical output and must not change underrun/dropout rates.
8. Only after the above: test bounded PCM capture, then prepared-PCM substitution, then exact rejoin. Keep the feature disabled by default until all tests pass.

## Intended adapter boundary

The portable SmartMix core must not know Spotify private classes or symbols. A future Objective-C++ adapter may implement a host-neutral interface with:

- source epoch and monotonically increasing source-frame position;
- explicit PCM format and borrowed-buffer lifetime;
- bounded copy into preallocated worker storage;
- asynchronous readiness of a fully rendered transition;
- a callback-safe tryReadPreparedFrames operation;
- explicit transition start and rejoin frame positions;
- cancellation and deterministic original-source passthrough.

No analysis, Core ML inference, disk I/O, network access, mutex wait, Objective-C allocation, or dynamic memory allocation is permitted on the real-time callback.

## Transition preparation constraint

The incoming track must be made available by Taurus's normal queue/streaming pipeline. A read-ahead API that only exposes the current track cannot supply incoming PCM. Do not obtain incoming audio through Alpha's YouTube Music download/provider path, a duplicate download, or a cloud service. If Beta does not expose incoming decoded PCM early enough, skip the smart transition and let Taurus play normally.

## Current conclusion
- Static symbol evidence: promising.
- Exact Beta source-processor ABI: unknown.
- Incoming next-track PCM availability: unknown.
- Safe frame-clock rejoin: unknown.
- Runtime validation on iPhone 16 Pro / iOS 27.2.1: not performed.

Do not claim the Beta adapter is implemented or working until these unknowns are resolved on the actual target build and device.

## Related upstream Taurus implementation evidence (version caveat)

The public Taurus project documentation describes a later Audio/SGAudioPipeline implementation with fixed processor slots, render-thread-safe graph changes, bounded generation-stamped PCM queues, and guarded read-ahead queue metadata. It explicitly distinguishes queue metadata used for read-ahead from PCM delivery: PCM still comes through the AudioUnit. The same documentation describes the Sing source adapter as tracking the audible clock by emitted source samples and retaining a worker/reserve when continuous next-track PCM is verified across a natural transition.

This is valuable architectural evidence that Taurus has used a source-domain PCM pipeline and a continuous-next-track strategy in a later codebase. It strengthens the rationale for investigating the Beta source processor and makes a single-source PCM insertion adapter a plausible design.

It does NOT establish that the supplied 0.60.7 Beta binary has the same implementation, exact ABI, queue semantics, or continuous-next-track behavior. The public project documentation describes a later source tree and a different target Spotify build. Do not copy undocumented prototypes or assume binary compatibility. The exact Beta runtime contract and iPhone 16 Pro validation remain required.

Reference: https://github.com/samj-exe/taurus/blob/stable/docs/tweaks.md (Audio and Sing sections).