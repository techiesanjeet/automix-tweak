# AutoMix Engine V2 (standalone)

This is a separate implementation. It does not call Taurus' `SGAutoMix*` functions and does not depend on Taurus' built-in AutoMix feature.

## Current implementation

- A standalone, exported dual-deck DSP interface.
- Equal-power crossfade gains: outgoing `cos(p·π/2)`, incoming `sin(p·π/2)`.
- Shared frame progress advanced only by the outgoing deck.
- Float32-only processing; unsupported formats are passed through untouched.
- Separate Theos target and GitHub Actions workflow producing `AutoMixEngineV2.dylib`.

## Important integration boundary

The engine deliberately does **not** guess Spotify's private player method signatures. A Spotify adapter still has to obtain two real, simultaneously rendering Spotify AudioUnits and call:

```objc
AMV2RegisterDeck(outgoingAudioUnit, 0);
AMV2RegisterDeck(incomingAudioUnit, 1);
AMV2StartTransition(6.0f);
```

Until that adapter exists and is validated on Spotify 9.1.90.2269, this dylib is a DSP engine prototype, **not a working Apple Music-style AutoMix tweak**. Merely registering two AudioUnits is not enough unless Spotify is actually rendering both tracks concurrently. The current engine will not manufacture a second Spotify playback session.

## Build

Run **Build Standalone AutoMix V2** in GitHub Actions. It builds a separate artifact named `AutoMixEngineV2-dylib`.

Target: arm64 / iOS 14.0+ SDK, intended for the user's Spotify/Taurus injection workflow. Runtime compatibility with iOS 27 and Spotify 9.1.90.2269 still needs on-device validation.
