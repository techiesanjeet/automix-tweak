# Local model plan

## Selected first model: Beat This! small0

Use the official CPJKU Beat This! small0 checkpoint as the first on-device ML component. It predicts beat and downbeat activations, which are the highest-value missing inputs for phrase-aware transitions. The official project lists small checkpoints at about 8.1 MB each and full checkpoints at about 78 MB; its code and published weights are MIT-licensed, with a separate caution that some training files have their own copyright or Creative Commons terms.

- Upstream: https://github.com/CPJKU/beat_this
- Paper: https://arxiv.org/abs/2407.21658
- License and model inventory: https://github.com/CPJKU/beat_this#available-models

## Why this model first

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

## Platform compatibility

The current Theos Makefile targets iOS 14. Keep the model runtime behind a narrow interface. Use Core ML where the selected model format and deployment target are supported; retain the C++ DSP fallback for unsupported iOS versions and devices. Do not raise the minimum iOS version until the compiled model and target devices are tested.

## Validation gates before enabling it by default

- Pin the exact upstream checkpoint and license notice.
- Convert the official checkpoint and compare beat/downbeat predictions against upstream PyTorch over a reproducible fixture set.
- Test tempo changes, half/double-time ambiguity, sparse intros, live drums, acoustic music, silence, and transitions across rolling-window boundaries.
- Measure inference latency, peak memory, thermal impact, and battery use on actual supported iPhones.
- Keep model inference off the real-time audio callback.
- Do not claim full AutoMix from beat tracking alone; vocal overlap, key compatibility, phrase/section detection, time-stretch, and true two-deck rendering remain separate components.
