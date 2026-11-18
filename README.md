# Taurus SmartMix

Streaming-compatible AutoMix engine: Taurus streams songs normally while analysis, transition planning, and mixing decisions run locally on-device.

## Goals
- Keep Taurus's normal online streaming and buffering path.
- Analyze decoded PCM locally; never upload track audio or features.
- Make transition decisions locally with deterministic DSP and a bundled Beat This small0 Core ML beat/downbeat model.
- Do not scrape or download substitute audio from external services.
- Mix two real sources; fading the current source alone is not Automix.
- Fail safely when the host cannot prepare and render two sources.

See [docs/ALPHA_RENDER_PATH.md](docs/ALPHA_RENDER_PATH.md) for the Alpha render/insertion reverse-engineering findings. See [docs/SMARTMIX_DESIGN.md](docs/SMARTMIX_DESIGN.md) for the Alpha-build findings and streaming architecture, [docs/LOCAL_MODEL.md](docs/LOCAL_MODEL.md) and [docs/BEAT_THIS_INPUT_CONTRACT.md](docs/BEAT_THIS_INPUT_CONTRACT.md) for the local beat/downbeat model plan and exact inference contract, and [docs/IMPLEMENTATION_STATUS.md](docs/IMPLEMENTATION_STATUS.md) for verified work, limitations, and next engineering gates.

## Status
**DSP/model prototype; live AutoMix is not yet enabled.** The arm64 Theos dylib and compiled local Core ML bundle have built successfully in GitHub Actions. The C++ test workflow and PyTorch/Core ML + native log-mel parity workflow pass. The current runtime surface is diagnostics only: it does not capture or alter Taurus playback. The remaining blocker is verifying a safe Beta source-processor integration and legitimate incoming next-track PCM path on the target device. Do not commit decrypted IPAs, app binaries, proprietary frameworks, or proprietary model weights.

## Build notes

The Theos arm64 target compiles the portable SmartMix core, local Core ML adapter, and read-only Beta source probe. GitHub Actions has produced a verified dylib + `SmartMixResources.bundle` artifact. Rootful and rootless Debian package builds are being validated separately. The `Makefile.diagnostics` target includes read-only runtime class discovery and a LOG report for collecting Taurus/iOS runtime evidence. Neither target establishes live mixing: the active engine intentionally leaves audio untouched until source ownership, incoming PCM, frame-clock and rejoin semantics are proven.
