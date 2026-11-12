# AutoMix playback-surface diagnostic

This branch builds a temporary diagnostic dylib, not an AutoMix implementation.

## What it does
- Adds an AM SCAN button when injected into Spotify.
- Scans loaded Objective-C class and method metadata for playback/audio/queue-related names.
- Lists relevant loaded images and frameworks.
- Copies a text report to the iOS clipboard.

## What it does not do
- It does not access, extract, decode, or copy Spotify audio.
- It does not change Spotify playback, queue, Automix, or Crossfade settings.
- It does not prove that a second playback deck exists. Runtime metadata is only a discovery aid.

## Build and test
Run the existing GitHub Actions workflow on this branch using workflow_dispatch. Download the AutoMixEngine-dylib artifact and locate the AutoMixProbe dylib inside it.

Inject this diagnostic build only into a test copy of your Spotify IPA. After Spotify opens, tap AM SCAN, then paste the copied report into the chat. Remove the diagnostic dylib after testing.

The existing main branch and original AutoMixEngine.mm are unchanged.
