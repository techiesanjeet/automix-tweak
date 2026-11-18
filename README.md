# Taurus SmartMix

Offline-first AutoMix engine with an optional Spotify/Taurus adapter.

## Goals
- Analyze locally available PCM on-device; never upload track audio.
- Make transition decisions locally with deterministic DSP.
- Do not scrape or download substitute audio from external services.
- Mix two real sources; fading the current source alone is not Automix.
- Fail safely when the host cannot prepare and render two sources.

See [docs/SMARTMIX_DESIGN.md](docs/SMARTMIX_DESIGN.md) for the Alpha-build findings and roadmap.

## Status
Research and architecture stage. The supplied Alpha IPA has been inspected at binary/string level; runtime behavior still requires on-device validation. Do not commit decrypted IPAs, app binaries, proprietary frameworks, or proprietary model weights.
