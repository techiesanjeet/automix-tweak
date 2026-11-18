# Diagnostic package usage

The rootful and rootless packages install a diagnostic build of SmartMix into the Taurus/Spotify app bundle filter (`com.spotify.client`). They are intended only for a compatible jailbroken device with a tweak loader such as ElleKit or MobileSubstrate.

## Important limitation

This is **not a working AutoMix release**. The package adds the local Beat This model, DSP core, and diagnostic UI, but it does not hook or change the music audio path. Tracks continue to play normally. No transition is attempted.

## What the diagnostic UI checks

1. Open Taurus/Spotify and tap **MIX STATUS**.
2. Choose **Test local model**. This loads the installed Core ML model and runs the native log-mel frontend plus model inference on a synthetic test signal. It does not use the playing song.
3. Start ordinary playback, open **MIX STATUS**, and choose **Probe Taurus pipeline**. This reads source-format and pipeline capability metadata. It does not register a source processor or pull/modify audio.
4. Use **Copy diagnostics** to copy symbol visibility and the current integration status.

The source probe is most useful while a track is actively playing. A positive read-ahead capability result does not prove that next-track PCM is available.

## Package choice

- Rootless jailbreak: install `AutoMixEngine-rootless.deb`.
- Rootful jailbreak: install `AutoMixEngine-rootful.deb`.

Do not install both. If the jailbreak type is unknown, do not guess; check the package manager/jailbreak's rootless or rootful documentation first.

## What must still be proven

The supplied Taurus 0.60.7 Beta has a single global source-processor callback/context slot. Its source-prefix/read-ahead exports are used by the examined Sing current-source capture path; they are not a demonstrated next-track PCM interface. A safe way to preserve any host-installed processor, expose incoming PCM through Taurus's normal streaming path, and rejoin at an exact source-frame boundary still needs runtime/device validation. Live mixing remains disabled until then.
