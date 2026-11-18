# Taurus SmartMix

Streaming-compatible AutoMix engine: Taurus streams songs normally while analysis, transition planning, and mixing decisions run locally on-device.

## Goals
- Keep Taurus's normal online streaming and buffering path.
- Analyze decoded PCM locally; never upload track audio or features.
- Make transition decisions locally with deterministic DSP and a future optional bundled on-device model.
- Do not scrape or download substitute audio from external services.
- Mix two real sources; fading the current source alone is not Automix.
- Fail safely when the host cannot prepare and render two sources.

See [docs/SMARTMIX_DESIGN.md](docs/SMARTMIX_DESIGN.md) for the Alpha-build findings and architecture, and [docs/IMPLEMENTATION_STATUS.md](docs/IMPLEMENTATION_STATUS.md) for verified work, limitations, and next engineering gates.

## Status
Research, architecture, and streaming-analysis prototype stage. The supplied Alpha IPA has been inspected at binary/string level; runtime behavior still requires on-device validation. Do not commit decrypted IPAs, app binaries, proprietary frameworks, or proprietary model weights.
