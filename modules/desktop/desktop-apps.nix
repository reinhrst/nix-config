{ pkgs }:

{
  # Desktop/GUI applications

  # Packages from nixpkgs (referenced by home.nix)
  packages = with pkgs; [
  ];

  # Apps installed via Homebrew (referenced by darwin.nix)
  casks = [
    "ghostty"
    "hammerspoon"
    "blender"
    "orbstack"
    "obsidian"
    "inkscape"
  ];
  onActivation = {
    autoUpdate = true;   # brew update on darwin-rebuild switch
    upgrade = true;      # brew upgrade on switch
    cleanup = "zap";     # remove anything not declared (optional)
  };
}
