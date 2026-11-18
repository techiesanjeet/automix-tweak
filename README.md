# Taurus SmartMix

Streaming-compatible AutoMix engine: Taurus streams songs normally while analysis, transition planning, and mixing decisions run locally on-device.

## Goals
- Keep Taurus's normal online streaming and buffering path.
- Analyze decoded PCM locally; never upload track audio or features.
- Make transition decisions locally with deterministic DSP and a future optional bundled on-device model.
- Do not scrape or download substitute audio from external services.
- Mix two real sources; fading the current source alone is not Automix.
- Fail safely when the host cannot prepare and render two sources.

See [docs/ALPHA_RENDER_PATH.md](docs/ALPHA_RENDER_PATH.md) for the Alpha render/insertion reverse-engineering findings. See [docs/SMARTMIX_DESIGN.md](docs/SMARTMIX_DESIGN.md) for the Alpha-build findings and streaming architecture, [docs/LOCAL_MODEL.md](docs/LOCAL_MODEL.md) and [docs/BEAT_THIS_INPUT_CONTRACT.md](docs/BEAT_THIS_INPUT_CONTRACT.md) for the local beat/downbeat model plan and exact inference contract, and [docs/IMPLEMENTATION_STATUS.md](docs/IMPLEMENTATION_STATUS.md) for verified work, limitations, and next engineering gates.

## Status
Research, architecture, and streaming-analysis prototype stage. The supplied Alpha IPA has been inspected at binary/string level; runtime behavior still requires on-device validation. Do not commit decrypted IPAs, app binaries, proprietary frameworks, or proprietary model weights.

## Build notes

The Theos library target is configured to compile the portable SmartMix core and its C ABI bridge (the Theos/iOS build itself has not yet been run here). The separate `Makefile.diagnostics` target includes read-only runtime class discovery and a LOG report for collecting Taurus/iOS runtime evidence. Neither target establishes dual-deck playback: the runtime adapter and device validation are still outstanding.
