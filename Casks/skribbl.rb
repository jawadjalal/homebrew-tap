cask "skribbl" do
  version "0.0.1"
  sha256 "8ffe3ab069887b4fcc4b2264fbcda21a85ad1af16729a0aeb446b83bfee9d4ba"

  url "https://github.com/jawadjalal/canvascode/releases/download/v#{version}/Skribbl-#{version}-arm64.dmg",
      verified: "github.com/jawadjalal/canvascode/"
  name "Skribbl"
  desc "Infinite canvas of real terminals and coding agents"
  homepage "https://skribbl.app/"

  livecheck do
    url :url
    strategy :github_latest
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
