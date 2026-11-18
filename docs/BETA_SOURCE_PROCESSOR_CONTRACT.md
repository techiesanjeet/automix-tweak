# Beta source-processor integration contract

## Purpose
Define the evidence required before implementing a Beta-specific PCM substitution adapter. The callback prototypes below are inferred from ARM64 disassembly, not guessed from symbol names; they remain subject to runtime confirmation.

## Static evidence from the supplied Beta binary

The ARM64 `spotifyglass.dylib` from Taurus 0.60.7 Beta was extracted and disassembled. The following prototypes are high-confidence static inferences from the function bodies and call register setup; they have not yet been runtime-invoked on the iPhone.

```cpp
using SGAudioPipelineSourceProcessor =
    OSStatus (*)(void *context,
                 UInt32 requestedFrames,
                 AudioBufferList *ioData,
                 const AudioTimeStamp *timeStamp);

bool SGAudioPipelineSetSourceProcessor(
    SGAudioPipelineSourceProcessor callback,
    void *context);

bool SGAudioPipelineClearSourceProcessor(void *context);
bool SGAudioPipelineSourceProcessorAttached(void *context);

OSStatus SGAudioPipelinePull(
    UInt32 requestedFrames,
    AudioBufferList *ioData,
    const AudioTimeStamp *timeStamp);

OSStatus SGAudioPipelinePullOriginal(
    UInt32 requestedFrames,
    AudioBufferList *ioData,
    const AudioTimeStamp *timeStamp);

bool SGAudioPipelineSourceFormat(AudioStreamBasicDescription *outFormat);
bool SGAudioPipelineSourceCanReadAhead(void);
```

Disassembly evidence:

- `SetSourceProcessor` stores its first argument as the callback and second as the context, then returns a boolean success value.
- `Pull` forwards the stored context plus its three original arguments to the callback. If no callback is installed, it calls the original-pull path.
- `ClearSourceProcessor(context)` and `SourceProcessorAttached(context)` compare the supplied context against the currently stored context.
- `PullOriginal` forwards the requested frame count, `AudioBufferList`, and timestamp into the original AudioUnit render path. The internal `PullOriginalAvailable` helper also has an optional fourth output-frame-count pointer.
- `SourceFormat` calls `AudioUnitGetProperty(kAudioUnitProperty_StreamFormat)` into the supplied ASBD.
- `SourceCanReadAhead` checks source-queue support/probe metadata and returns a boolean.

The registration implementation appears to use **one global callback/context slot**, not an evident multi-processor chain. Replacing it could overwrite a host-installed processor. The `SourceProcessorAttached(context)` check only tests that exact context; passing NULL does not enumerate arbitrary attached processors. Therefore the adapter deliberately does not call `SetSourceProcessor` yet.

The setter itself checks that the active AudioUnit format is 44.1 kHz and has two channels. The original-pull implementation then validates an AudioBufferList with two buffers, one channel per buffer, non-null data pointers, and at least four bytes per requested frame per buffer. This is consistent with planar Float32 stereo; the ASBD probe must confirm the actual format flags and bit depth before any future PCM interpretation. The setter also waits for an internal render-state flag to clear while holding a control-path mutex, so registration/clear must never run on the render callback.

`SourcePrefix` / `SourceAheadFrames` are **not** treated as a decoded next-track API. `SourceCanReadAhead` only reports source-queue capability. The argument/return semantics and source identity for `SourcePrefix` / `SourceAheadFrames` remain unresolved; the adapter does not call them.

## Required contract (must be measured, not guessed)

| Contract item | Evidence required | Safe implementation rule |
|---|---|---|
| Registration | Callback and context arguments/boolean return are inferred; lifecycle and slot ownership still need runtime confirmation | Do not register until current callback ownership can be preserved |
| Processor callback | Prototype inferred as `(context, UInt32 frames, AudioBufferList*, AudioTimeStamp*)`; invocation thread/reentrancy still unverified | Callback must be bounded, nonblocking and allocation-free |
| Source identity | How a source is identified and replaced | Bind captured PCM to a source epoch; invalidate on replacement |
| PCM format | Setter checks 44.1 kHz/two channels; original pull expects two one-channel buffers with four bytes/frame; confirm ASBD flags and bit depth | Reject unsupported formats; never reinterpret unknown buffers |
| Buffer ownership | Who allocates, owns, retains and releases input/output memory | Copy only into preallocated bounded storage; never retain borrowed pointers |
| Pull semantics | `Pull` dispatches the installed processor or original path; `PullOriginal` bypasses the processor | Preserve exactly-once original pull semantics; no recursive pull |
| Read-ahead | Meaning and limits of SourceAheadFrames / SourceCanReadAhead | Do not infer next-track availability from current-source lookahead |
| Clock | Frame counter domain, reset conditions, timestamp relation and discontinuity handling | Schedule insertion only against a verified source-frame clock |
| Processor chaining | One global callback/context slot is visible; no getter or chain API found | Never replace an existing host processor without a verified chain mechanism |
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
- Exact Beta source-processor ABI: callback and pull prototypes inferred from ARM64 disassembly; not runtime-verified.
- Incoming next-track PCM availability: unknown.
- Safe frame-clock rejoin: unknown.
- Single-slot callback ownership/chaining: unresolved; do not install a competing processor.
- Runtime validation on iPhone 16 Pro / iOS 27.2.1: not performed.

Do not claim the Beta adapter is implemented or working until these unknowns are resolved on the actual target build and device.

## Related upstream Taurus implementation evidence (version caveat)

The public Taurus project documentation describes a later Audio/SGAudioPipeline implementation with fixed processor slots, render-thread-safe graph changes, bounded generation-stamped PCM queues, and guarded read-ahead queue metadata. It explicitly distinguishes queue metadata used for read-ahead from PCM delivery: PCM still comes through the AudioUnit. The same documentation describes the Sing source adapter as tracking the audible clock by emitted source samples and retaining a worker/reserve when continuous next-track PCM is verified across a natural transition.

This is valuable architectural evidence that Taurus has used a source-domain PCM pipeline and a continuous-next-track strategy in a later codebase. It strengthens the rationale for investigating the Beta source processor and makes a single-source PCM insertion adapter a plausible design.

It does NOT establish that the supplied 0.60.7 Beta binary has the same implementation, exact ABI, queue semantics, or continuous-next-track behavior. The public project documentation describes a later source tree and a different target Spotify build. Do not copy undocumented prototypes or assume binary compatibility. The exact Beta runtime contract and iPhone 16 Pro validation remain required.

Reference: https://github.com/samj-exe/taurus/blob/stable/docs/tweaks.md (Audio and Sing sections).

## Implemented non-invasive probe

`BetaSourceProcessorProbe.mm` resolves the source-format query, the source-queue read-ahead capability probe, and the NULL-context-attached query. The diagnostics UI can report the current ASBD and those flags. The read-ahead capability call may update internal probe metadata, but the probe does not register a callback, pull PCM, retain audio buffers, or change output samples. The probe must be run while Taurus playback is active to obtain a meaningful source format.
