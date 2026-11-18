# Beat This! model input/output contract

This note records the upstream inference contract at CPJKU/beat_this commit
`b95c8ab0c58c2d9fcfd40508ae8dffbc05ac4f5c`. Re-check the upstream revision before
updating the converter.

## Audio and spectrogram input

- Input is mono audio. Stereo input is averaged across channels.
- Resample to 22,050 Hz before feature extraction.
- Log-mel spectrogram: FFT 1,024; hop 441 samples (20 ms); 128 mel bins;
  30 Hz to 11,000 Hz; Slaney mel scale with unnormalized triangular filters (`norm=None`); frame-length normalization; power 1.
- Apply `log1p(1000 * mel)`.
- The network accepts a spectrogram shaped as time × 128 mel bins and emits
  framewise beat and downbeat logits.

The upstream preprocessing implementation uses torchaudio's MelSpectrogram
and the inference wrapper uses soxr for resampling. A native implementation
must be parity-tested against these exact settings; substituting Apple's
vDSP/Accelerate mel pipeline without parity tests is not acceptable.

## Model and temporal chunking

- The selected checkpoint is `small0`, documented upstream at about 8.1 MB.
- The official checkpoint download used by the export workflow has SHA-256 `6074be2c4d490c5f6101fcc374a1ec72ae93456e23bb6019783b849f5dc7d47b`; the workflow verifies this before conversion.
- The official checkpoints are PyTorch Lightning checkpoint files; the
  upstream loader reconstructs the model from checkpoint hyperparameters and
  strips the `model.` state-dict prefix.
- Upstream frame inference uses 1,500-frame chunks with a six-frame border
  discarded on each side. Chunks overlap so their interior predictions can
  be stitched without using edge predictions.
- The model predicts beat and downbeat activations. It does not predict
  musical key, vocals, stems, song sections, transition points, or mix effects.

## Strict offline requirement

The upstream convenience loader downloads a checkpoint when a short model
name such as `small0` is not found locally. The iOS runtime must never use
that fallback. Package a verified local model asset and fail closed to the
DSP fallback if it is missing. No model fetch, audio upload, feature upload,
or inference request is permitted during playback.

## Conversion gates

1. Download the official `small0` checkpoint only during development/build
   preparation, pin its SHA-256 and retain the upstream MIT notice.
2. Export the model and preprocessing separately or together; keep a stable
   20 ms frame convention and explicit output names for beat/downbeat logits.
3. Compare converted logits against upstream PyTorch on fixed licensed audio
   fixtures. Record max/mean absolute error and beat/downbeat event agreement.
4. Test long-file chunk boundaries and overlap stitching against upstream.
5. Benchmark Core ML on the iPhone 16 Pro. If Core ML conversion fails or is
   slower/too memory hungry, evaluate a bundled ONNX Runtime/Core ML execution
   path. Do not silently switch model formats without parity evidence.
6. Bundle the model and runtime in the tweak package. Runtime loading must use
   a local filesystem/resource path only.

## Source references

- Official implementation: https://github.com/CPJKU/beat_this
- Pinned upstream revision: https://github.com/CPJKU/beat_this/tree/b95c8ab0c58c2d9fcfd40508ae8dffbc05ac4f5c
- Upstream MIT license: https://github.com/CPJKU/beat_this/blob/b95c8ab0c58c2d9fcfd40508ae8dffbc05ac4f5c/LICENSE
- Paper: https://arxiv.org/abs/2407.21658

## Repository conversion tooling

- Exporter: `tools/export_beat_this_coreml.py`.
- Build-time workflow: `.github/workflows/beat-this-coreml.yml`.
- The workflow checks out the pinned upstream source, downloads the official checkpoint only during CI, converts a fixed 1500-frame model, and requires CPU Core ML/PyTorch logit parity before uploading the `.mlpackage` artifact.
- This artifact is not yet bundled into the tweak or loaded by the iOS runtime. The runtime must use a local bundled path only.


## Native frontend parity result

The C++ frontend now matches the pinned upstream torchaudio transform on a deterministic three-second waveform. The parity fixture produced shape `[151, 128]`, maximum absolute error `1.91e-5`, and mean absolute error `1.76e-6`. The implementation uses the upstream Slaney frequency mapping with `norm=None`, frame-length normalization, periodic Hann window, centered reflect padding, and `log1p(1000 * mel)`.


## Taurus Beta PCM adaptation

The new `prepareBeatThisMono22050` worker-side adapter accepts the inferred Beta planar Float32 stereo layout as explicit left/right channel pointers, validates finite samples and source rate, downmixes to mono, and uses the bounded windowed-sinc resampler to convert to 22050 Hz. It allocates its result and must only run on a worker thread, never inside the source render callback. Portable tests cover 44.1 kHz stereo input, output sample count, 1 kHz tone preservation, invalid sample rates, and non-finite samples.

This is a format adapter only. It does not capture PCM from Taurus, establish source identity, or expose incoming next-track audio.
