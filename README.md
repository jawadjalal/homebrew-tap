# jawadjalal/tap

Homebrew tap for [Skribbl](https://skribbl.dev): an infinite canvas of real terminals and coding
agents.

## Install

```sh
brew tap jawadjalal/tap && brew trust jawadjalal/tap && brew install --cask skribbl
```

Then, once:

```sh
xattr -dr com.apple.quarantine /Applications/Skribbl.app
```

**Three steps, not one, and all three are Homebrew 6 changes.** If you have seen a shorter
version of this line anywhere, it was written for Homebrew 5 and it will not work:

- `brew install jawadjalal/tap/skribbl` **no longer auto-taps.** It fails with "This command
  requires the tap jawadjalal/tap".
- `brew trust` is new. Homebrew 6 refuses to load a cask from a third-party tap until you say
  you trust it: "Refusing to load cask ... from untrusted tap".
- `--no-quarantine` **was removed.** It now fails outright with `Error: invalid option`.

That last one is why the `xattr` line is no longer optional. Skribbl is ad-hoc signed rather
than notarized, Homebrew always quarantines what it downloads, and there is no flag left to opt
out - so Gatekeeper will call the app damaged until you clear the flag yourself. Signing and
notarizing removes this step entirely, and it is the reason to eventually pay Apple.

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
