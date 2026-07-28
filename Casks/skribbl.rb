cask "skribbl" do
  version "0.0.1"
  sha256 "ac26adc2e2b49e5b3ebb1d681594f3bbedb97be2e0644a83768facb27f0acced"

  # Self-hosted. The source repo is private, so a GitHub release asset could never be
  # fetched by a cask - Homebrew cannot authenticate, and that URL 404'd for everyone.
  # No `verified:` line: the download host matches `homepage`, so Homebrew does not need one.
  url "https://skribbl.dev/downloads/Skribbl-#{version}-arm64.dmg"
  name "Skribbl"
  desc "Infinite canvas of real terminals and coding agents"
  homepage "https://skribbl.dev/"

  # The app's own update feed doubles as the version source. `:github_latest` watched a
  # releases page that does not exist and never will.
  livecheck do
    url "https://skribbl.dev/downloads/latest-mac.yml"
    strategy :page_match
    regex(/^version:\s*(\d+(?:\.\d+)+)/i)
  end

  # Apple Silicon only: package.json builds a single arm64 dmg. Add an x64 target and a second
  # `sha256`/`url` pair keyed on `Hardware::CPU.intel?` if that ever changes.
  depends_on arch: :arm64
  # Electron 33.
  depends_on macos: ">= :catalina"

  app "Skribbl.app"

  # Skribbl is ad-hoc signed rather than Developer ID signed and notarized, so Gatekeeper will
  # refuse a quarantined copy. Homebrew quarantines downloads by default, so install with
  # `--no-quarantine` (see the tap README). This stanza cannot opt out on the user's behalf.

  zap trash: [
    # Canvas, scrollback snapshots, link sidecars, hook endpoint and status mirror.
    "~/Library/Application Support/skribbl",
    "~/Library/Preferences/team.bevel.skribbl.plist",
    "~/Library/Saved Application State/team.bevel.skribbl.savedState",
    "~/Library/Logs/skribbl",
  ]

  caveats <<~EOS
    Skribbl runs shells and coding agents inside your project folders, so macOS will ask for
    access to Documents, Desktop or Downloads the first time you open a project there.

    This build is not notarized. If you installed without `--no-quarantine` and macOS says the
    app is damaged, clear the quarantine flag once:

      xattr -dr com.apple.quarantine /Applications/Skribbl.app
  EOS
end
