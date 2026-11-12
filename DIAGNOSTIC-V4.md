# Spotify AutoMix targeted discovery v4

This diagnostic focuses on the exact MultiPlayer, audio coordinator, mixing transition player, Automix evaluator/loader and A/B transition-proto classes surfaced by v3.

It records runtime class/superclass chains, ivar names/type encodings/offsets, declared properties, protocols, protocol method descriptions, and selector type encodings. It does **not** instantiate Spotify objects or invoke Spotify methods; it does not read audio buffers, decode media, or inspect track contents.

This cannot prove that a second music player can be independently started or mixed. It identifies the exposed interfaces and type relationships without triggering playback.

## Build
GitHub Actions workflow: **Build Spotify AutoMix Targeted Discovery Diagnostic v4**. Download artifact **AutoMixDiscovery-v4-dylib**.

## Run
Inject the dylib into the same Spotify 9.1.90 IPA, install and launch Spotify. After about 15 seconds, tap **AUTOMIX SCAN V4** and share `AutoMix-Spotify-Discovery-v4.txt`.
