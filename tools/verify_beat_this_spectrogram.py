#!/usr/bin/env python3
"""Compare the C++ Beat This log-mel frontend with the pinned upstream PyTorch transform."""
from __future__ import annotations

import argparse
from pathlib import Path
import subprocess
import tempfile

import numpy as np
import torch
from beat_this.preprocessing import LogMelSpect


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--max-absolute-error", type=float, default=0.003)
    parser.add_argument("--mean-absolute-error", type=float, default=0.0002)
    args = parser.parse_args()

    torch.set_num_threads(1)
    sample_rate = 22050
    sample_count = sample_rate * 3
    time = np.arange(sample_count, dtype=np.float64) / sample_rate
    rng = np.random.default_rng(20261118)
    waveform = (
        0.31 * np.sin(2.0 * np.pi * 440.0 * time)
        + 0.17 * np.sin(2.0 * np.pi * 1320.0 * time + 0.2)
        + 0.015 * rng.standard_normal(sample_count)
    ).astype(np.float32)

    reference = LogMelSpect(device="cpu")(torch.from_numpy(waveform))
    reference = reference.detach().cpu().numpy().astype(np.float32)
    root = Path(__file__).resolve().parents[1]
    with tempfile.TemporaryDirectory(prefix="beat-this-mel-") as temp:
        temp_path = Path(temp)
        input_path = temp_path / "input.f32"
        output_path = temp_path / "output.f32"
        executable = temp_path / "spectrogram_cli"
        waveform.tofile(input_path)
        subprocess.run(
            [
                "clang++", "-std=c++17", "-O2",
                "-I", str(root / "SmartMixCore/include"),
                str(root / "SmartMixCore/src/BeatThisSpectrogram.cpp"),
                str(root / "tools/beat_this_spectrogram_cli.cpp"),
                "-o", str(executable),
            ],
            check=True,
        )
        subprocess.run(
            [str(executable), str(input_path), str(sample_count), str(output_path)],
            check=True,
        )
        observed = np.fromfile(output_path, dtype=np.float32).reshape(reference.shape)

    difference = np.abs(observed - reference)
    maximum = float(difference.max(initial=0.0))
    mean = float(difference.mean())
    print({
        "shape": list(reference.shape),
        "max_absolute_error": maximum,
        "mean_absolute_error": mean,
    })
    if maximum > args.max_absolute_error or mean > args.mean_absolute_error:
        raise SystemExit("C++ log-mel preprocessing does not match upstream torchaudio")


if __name__ == "__main__":
    main()
