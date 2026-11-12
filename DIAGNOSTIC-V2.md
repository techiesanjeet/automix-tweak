# Spotify Playback Discovery Diagnostic v2

This is a separate diagnostic branch. It does not replace or modify the AutoMixEngine source on `main`.

## What it does

- Scans Objective-C runtime class metadata and loaded Mach-O image names.
- Filters for player, audio, stream, queue, track, playback, decoder, renderer, engine, mix, deck, session, media, crossfade, and related names.
- Records class names, image paths, superclass names, ivar names/type encodings, properties, and Objective-C selectors.
- Does **not** call Spotify methods, inspect audio buffers, read decoded media, or access account/track content.

## Build

Open GitHub Actions, select **Build Spotify Discovery Diagnostic v2**, choose branch `diagnostics/spotify-playback-discovery-v2`, and run the workflow. Download the `AutoMixDiscovery-v2-dylib` artifact.

Inject this diagnostic dylib into the same Spotify IPA used for the first report. Launch Spotify, start a track, open a playlist with Spotify's Mix feature if available, and let it sit for 15 seconds. Tap **SCAN + SHARE** to run a fresh scan and share `AutoMix-Spotify-Discovery-v2.txt`.

The output is metadata evidence only. A class or selector name is not proof that a second playback deck is usable.
