cask "skribbl" do
  version "0.0.5"
  sha256 "578fafd35d77b87c4040a9db9fee184f4b311e1ebe6fff668dc8c7095ea527f4"

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
  # Electron 33. `:catalina` already means "or newer"; the ">= :catalina" string
  # form is deprecated in Homebrew 6 and prints a warning on every install.
  depends_on macos: :catalina

  app "Skribbl.app"

  # Skribbl is ad-hoc signed rather than Developer ID signed and notarized, so Gatekeeper will
  # refuse a quarantined copy. Homebrew 6 REMOVED `--no-quarantine` (`Error: invalid option`),
  # and a cask cannot opt out on the user's behalf, so clearing the flag afterwards is now the
  # only route. The caveats below say so; do not reinstate the old flag in any instructions.

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

    This build is not notarized, and Homebrew always quarantines what it downloads, so macOS
    will call it damaged until you clear the flag. Run this once, now:

      xattr -dr com.apple.quarantine /Applications/Skribbl.app

    (`--no-quarantine` no longer exists: Homebrew 6 removed it.)

    Updates are `brew upgrade --cask skribbl`. Homebrew never upgrades on its own, so Skribbl
    tells you when a version is out and hands you that command.
  EOS
end
