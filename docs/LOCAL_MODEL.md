# Local model plan

## Selected first model: Beat This! small0

Use the official CPJKU Beat This! small0 checkpoint as the first on-device ML component. It predicts beat and downbeat activations, which are the highest-value missing inputs for phrase-aware transitions. The official project lists small checkpoints at about 8.1 MB each and full checkpoints at about 78 MB; its code and published weights are MIT-licensed, with a separate caution that some training files have their own copyright or Creative Commons terms.

- Upstream: https://github.com/CPJKU/beat_this
- Paper: https://arxiv.org/abs/2407.21658
- License and model inventory: https://github.com/CPJKU/beat_this#available-models

See `docs/BEAT_THIS_INPUT_CONTRACT.md` for the pinned upstream revision, exact audio/spectrogram settings, chunking, and strict local-loader rules. The official inference loader can download a missing named checkpoint; the iOS adapter must pass a bundled local path and must not call the network-capable fallback.\n\n## Why this model first

- Beat and downbeat predictions are more useful for musical phrase alignment than the current RMS-envelope autocorrelation prototype.
- The small checkpoint is a practical first asset for an iOS tweak; the full checkpoint is substantially larger.
- The model can be converted to Core ML or ONNX for local inference. Treat conversion as our own engineering task: pin the upstream checkpoint/revision and verify converted output against upstream PyTorch on a deterministic fixture before shipping.
- A third-party project demonstrates a compact Core ML conversion, but this repository should use the official checkpoint and independently verify its conversion rather than copying another app's implementation or model asset.

## Runtime contract

1. Taurus continues streaming and buffering songs normally.
2. The adapter obtains only PCM already decoded and legitimately exposed by Taurus.
3. A background worker resamples/downmixes bounded windows to the model's required input format.
4. The local model emits beat/downbeat activations. A postprocessor converts peaks into a beat grid and downbeat/measure labels.
5. SmartMix combines that grid with locally computed loudness, onset density, intro/outro and section features to score transition candidates.
6. The render callback consumes only a precomputed plan and ready buffers. It never runs inference.

The model asset must be bundled with the tweak/app or installed by an explicit user-controlled package step. There must be no model download, cloud inference, telemetry upload, or transition-plan request during playback. If the model asset is missing or inference fails, use the existing deterministic DSP fallback and lower the transition confidence.

## Primary device and deployment strategy

Primary validation device supplied by the user: **iPhone 16 Pro running iOS 27.2.1**.

- Treat this as the first performance, audio-routing, thermal, and real-playback validation target—not as the minimum deployment version.
- Prefer a Core ML model package for on-device inference on this device, with compute-unit selection benchmarked rather than assuming Neural Engine-only execution is always fastest or most compatible.
- Keep model invocation behind a small C++/Objective-C++ adapter so the DSP core does not depend directly on Core ML.
- Keep the existing Theos deployment target at iOS 14.0 for now. Add availability checks and retain the DSP fallback on older supported systems; only raise the minimum if a measured model/runtime requirement makes it unavoidable.
- Build against the installed current Xcode/iOS SDK, then verify the actual tweak injection, model loading, audio session behavior, and inference latency on the supplied iOS 27.2.1 device.
- Benchmark sustained inference while Taurus is streaming, including thermal throttling, memory pressure, battery drain, route changes, interruptions, and background/foreground transitions.

## Validation gates before enabling it by default

- Pin the exact upstream checkpoint and license notice.
- Convert the official checkpoint and compare beat/downbeat predictions against upstream PyTorch over a reproducible fixture set.
- Test tempo changes, half/double-time ambiguity, sparse intros, live drums, acoustic music, silence, and transitions across rolling-window boundaries.
- Measure inference latency, peak memory, thermal impact, and battery use on actual supported iPhones.
- Keep model inference off the real-time audio callback.
- Do not claim full AutoMix from beat tracking alone; vocal overlap, key compatibility, phrase/section detection, time-stretch, and true two-deck rendering remain separate components.


## Core ML conversion result

The first pinned small0 conversion succeeded on an Apple Silicon macOS runner:

- Upstream source commit: `b95c8ab0c58c2d9fcfd40508ae8dffbc05ac4f5c`.
- Checkpoint SHA-256: `6074be2c4d490c5f6101fcc374a1ec72ae93456e23bb6019783b849f5dc7d47b`.
- Toolchain: PyTorch 2.5.0, Core ML Tools 8.3.0, float32 ML Program, minimum Core ML deployment iOS 16.
- Fixed input: `[1, 1500, 128]` float32 log-mel frames. Outputs are beat and downbeat logits, each `[1, 1500]`.
- CPU parity against upstream PyTorch passed: maximum absolute error was about `3.8e-6`; mean absolute error was below `9e-7` for both outputs.
- Verified model artifact: `BeatThisSmall0-CoreML` in GitHub Actions run 44259698594. The model is about 8.8 MB uncompressed inside its package.

The trace is intentionally fixed-shape. Upstream trace warnings indicate that a different time dimension is not guaranteed to work; callers supply exactly 1500 frames and apply the upstream six-frame edge trimming when stitching chunks. The compiled `.mlmodelc` is bundled in the rootful and rootless diagnostic packages. Core ML runtime performance has not yet been benchmarked on iPhone.

Exporter: `tools/export_beat_this_coreml.py`. Reproducible workflow: `.github/workflows/beat-this-coreml.yml`. It downloads the pinned checkpoint only during CI, verifies its hash, converts it, and checks PyTorch/Core ML parity. Runtime playback must use a bundled local `.mlmodelc` path only.


## Native runtime adapter status

- `BeatThisCoreML.mm` loads the compiled model from a local `SmartMixResources.bundle`, checking the dylib-adjacent, rootful, rootless, and app-bundle locations. It contains no checkpoint downloader or network fallback.
- `SMBeatThisPredictMonoChunk` accepts mono 22050 Hz PCM, applies the native log-mel frontend, pads a fixed 1500-frame chunk with the upstream six-frame border, and returns beat/downbeat logits. It is a worker-thread API.
- `SMBeatThisPredictMonoTrack` now handles full tracks: it computes the full log-mel spectrogram, splits it into fixed 1500-frame windows with six-frame borders, predicts sequentially, and stitches logits with the pinned upstream `keep_first` policy. Clips shorter than 1488 model frames use the lightweight DSP fallback.
- `SMApplyBeatThisLogitsToTrack` postprocesses logits, estimates a reliable 3/4 or 4/4 meter when possible, and updates the planner track through the C bridge.
- The status UI now runs the full-track chunked inference path on a synthetic 60-second 220 Hz signal and checks that every returned beat/downbeat logit is finite. It does not inspect or alter live Taurus audio.
- The native log-mel implementation matches the pinned torchaudio frontend on the deterministic three-second parity fixture: maximum absolute error `1.91e-5`, mean absolute error `1.76e-6`. Full-track chunk planning and stitching are covered by portable C++ tests.
- The resource-bundle build workflow compiles the `.mlpackage` to `.mlmodelc` and stages it alongside the arm64 dylib. Rootful and rootless package builds and payload verification passed in Theos workflow run `44265182450`; the latest build with full-track inference is being checked separately.
