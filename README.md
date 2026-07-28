# jawadjalal/tap

Homebrew tap for [Skribbl](https://skribbl.dev): an infinite canvas of real terminals and coding
agents.

## Install

```sh
brew install --cask --no-quarantine jawadjalal/tap/skribbl
```

`--no-quarantine` is needed because Skribbl is not yet notarized by Apple. Homebrew quarantines
downloads by default, and Gatekeeper refuses to open a quarantined app that is not signed with a
Developer ID certificate. The flag skips that step for this install only.

If you leave the flag off and macOS says the app is damaged, clear the flag once:

```sh
xattr -dr com.apple.quarantine /Applications/Skribbl.app
```

## Update

```sh
brew upgrade --cask skribbl
```

## Uninstall

```sh
brew uninstall --cask skribbl
```

That removes the app but keeps your canvases. To delete those too, including saved terminal
scrollback:

```sh
brew uninstall --zap --cask skribbl
```

## Requirements

Apple Silicon, macOS 10.15 or later. There is no Intel build.

## Releasing a new version

The cask points at `skribbl.dev/downloads/`, which the app repo is private is exactly why: a
cask cannot authenticate against a private GitHub release, so the artifacts are self-hosted.

1. Bump `version` in the app's `package.json`.
2. `npm run dist` on an arm64 Mac. This produces FOUR artifacts in `release/`, and all four
   have to be uploaded - the dmg is what a human downloads, but the **zip** is what the
   in-app updater applies, and `latest-mac.yml` is the feed it reads:

   ```
   Skribbl-<version>-arm64.dmg          Skribbl-<version>-arm64-mac.zip
   Skribbl-<version>-arm64.dmg.blockmap Skribbl-<version>-arm64-mac.zip.blockmap
   latest-mac.yml
   ```

3. Upload all five to Vercel Blob under `downloads/`, with no random suffix so the URL stays
   a pure function of the filename.
4. Get the checksum of the dmg:

   ```sh
   shasum -a 256 release/Skribbl-<version>-arm64.dmg
   ```

5. Update `version` and `sha256` in `Casks/skribbl.rb`, then commit and push.

Check the result before announcing it:

```sh
brew audit --cask --online jawadjalal/tap/skribbl
```
