# jawadjalal/tap

Homebrew tap for [Skribbl](https://skribbl.app): an infinite canvas of real terminals and coding
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

The cask points at a GitHub release asset on
[jawadjalal/canvascode](https://github.com/jawadjalal/canvascode), so publish the release first,
then update this tap:

1. Bump `version` in the app's `package.json`.
2. `npm run release` to build and upload the dmg to a GitHub release tagged `v<version>`.
3. Get the checksum of the published dmg:

   ```sh
   shasum -a 256 release/Skribbl-<version>-arm64.dmg
   ```

4. Update `version` and `sha256` in `Casks/skribbl.rb`, then commit and push.

Check the result before announcing it:

```sh
brew audit --cask --online jawadjalal/tap/skribbl
```
