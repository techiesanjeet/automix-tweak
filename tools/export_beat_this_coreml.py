#!/usr/bin/env python3
"""Export the pinned official Beat This! small0 checkpoint to a fixed-shape Core ML model.

This is a development/build-time tool only. The iOS runtime must load the resulting
bundled .mlpackage from disk and must never invoke the upstream checkpoint downloader.
"""
from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path

import coremltools as ct
import numpy as np
import torch


UPSTREAM_COMMIT = "b95c8ab0c58c2d9fcfd40508ae8dffbc05ac4f5c"
CHECKPOINT_NAME = "small0"
FRAME_COUNT = 1500
MEL_BINS = 128


class BeatOutputWrapper(torch.nn.Module):
    def __init__(self, model: torch.nn.Module):
        super().__init__()
        self.model = model.eval()

    def forward(self, spectrogram: torch.Tensor):
        prediction = self.model(spectrogram)
        return prediction["beat"], prediction["downbeat"]


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for chunk in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--checkpoint", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--expected-sha256", default="")
    parser.add_argument("--max-absolute-error", type=float, default=0.05)
    parser.add_argument("--mean-absolute-error", type=float, default=0.005)
    args = parser.parse_args()

    if not args.checkpoint.is_file():
        raise SystemExit(f"checkpoint not found: {args.checkpoint}")
    checkpoint_hash = sha256(args.checkpoint)
    if args.expected_sha256 and checkpoint_hash.lower() != args.expected_sha256.lower():
        raise SystemExit(
            f"checkpoint SHA-256 mismatch: expected {args.expected_sha256}, "
            f"got {checkpoint_hash}"
        )

    # The pinned upstream checkout is added to PYTHONPATH by the CI workflow.
    from beat_this.inference import load_model

    torch.set_num_threads(2)
    torch.manual_seed(20261118)
    model = load_model(str(args.checkpoint), device="cpu").eval()
    wrapper = BeatOutputWrapper(model).eval()

    # Fixed 1500-frame input matches the upstream inference chunk size. The
    # upstream caller discards six edge frames on either side when stitching.
    example = torch.rand((1, FRAME_COUNT, MEL_BINS), dtype=torch.float32) * 4.0
    with torch.inference_mode():
        eager_beat, eager_downbeat = wrapper(example)

    traced = torch.jit.trace(wrapper, example, strict=False, check_trace=False)
    args.output.parent.mkdir(parents=True, exist_ok=True)
    converted = ct.convert(
        traced,
        source="pytorch",
        inputs=[ct.TensorType(name="spectrogram", shape=tuple(example.shape))],
        outputs=[
            ct.TensorType(name="beat_logits"),
            ct.TensorType(name="downbeat_logits"),
        ],
        convert_to="mlprogram",
        minimum_deployment_target=ct.target.iOS16,
        compute_precision=ct.precision.FLOAT32,
    )
    converted.author = "CPJKU Beat This! small0 — locally converted"
    converted.short_description = (
        "Beat and downbeat logits for a 1500-frame, 128-bin log-mel spectrogram."
    )
    converted.version = f"beat-this-small0-{UPSTREAM_COMMIT[:12]}"
    converted.save(str(args.output))

    # Validate the converted model on CPU before accepting the artifact.
    coreml_model = ct.models.MLModel(str(args.output), compute_units=ct.ComputeUnit.CPU_ONLY)
    actual = coreml_model.predict({"spectrogram": example.numpy()})
    comparisons = []
    for name, expected in (
        ("beat_logits", eager_beat.detach().cpu().numpy()),
        ("downbeat_logits", eager_downbeat.detach().cpu().numpy()),
    ):
        observed = np.asarray(actual[name], dtype=np.float32)
        expected = np.asarray(expected, dtype=np.float32)
        if observed.shape != expected.shape:
            raise SystemExit(
                f"{name} shape mismatch: Core ML {observed.shape}, PyTorch {expected.shape}"
            )
        difference = np.abs(observed - expected)
        max_error = float(difference.max(initial=0.0))
        mean_error = float(difference.mean())
        comparisons.append({
            "output": name,
            "shape": list(observed.shape),
            "max_absolute_error": max_error,
            "mean_absolute_error": mean_error,
        })
        if max_error > args.max_absolute_error or mean_error > args.mean_absolute_error:
            raise SystemExit(
                f"{name} parity failed: max={max_error:.6g}, mean={mean_error:.6g}"
            )

    manifest = {
        "model": CHECKPOINT_NAME,
        "upstream_repository": "https://github.com/CPJKU/beat_this",
        "upstream_commit": UPSTREAM_COMMIT,
        "checkpoint_sha256": checkpoint_hash,
        "checkpoint_bytes": args.checkpoint.stat().st_size,
        "input": {
            "name": "spectrogram",
            "shape": [1, FRAME_COUNT, MEL_BINS],
            "dtype": "float32",
            "meaning": "time x 128-bin log-mel spectrogram",
            "upstream_audio_sample_rate": 22050,
            "upstream_hop_length": 441,
        },
        "outputs": comparisons,
        "torch_version": torch.__version__,
        "coremltools_version": ct.__version__,
        "minimum_deployment_target": "iOS 16",
        "compute_precision": "float32",
    }
    manifest_path = args.output.parent / "BeatThisSmall0-manifest.json"
    manifest_path.write_text(json.dumps(manifest, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(manifest, indent=2))


if __name__ == "__main__":
    main()
