# Spotify AutoMix targeted diagnostic v3

This branch is separate from `main`. It builds a compact metadata-only diagnostic for the Spotify runtime classes surfaced in the previous report.

Targets include:
- `PlaylistMixing_*`
- `Spotify_Automix_*`
- `MultiPlayer_*`
- `NowPlaying_MixingTransition*`
- transition-player and player-group class names

It records class names, image paths, superclasses, directly exposed ivars, properties, protocols and selectors. It does not invoke Spotify methods or read audio buffers, decoded media, credentials or track contents. It is capped to keep the exported report small.

## Build
Open the GitHub Actions workflow **Build Spotify Targeted Discovery Diagnostic v3**, then download artifact `AutoMixDiscovery-v3-dylib`.

## Run
Inject the dylib into the same Spotify IPA/version as the earlier report, install, launch Spotify and tap **AUTOMIX SCAN V3**. Share the resulting `AutoMix-Spotify-Discovery-v3.txt` file back.

This is an investigation tool, not an AutoMix playback implementation. Runtime metadata can identify promising integration points but cannot prove that a second audio deck is callable or safe to use.
