_:

{
  # Desktop/GUI applications, installed via Homebrew (referenced by darwin.nix)
  casks = [
    "ghostty"
    "hammerspoon"
    "blender"
    "orbstack"
    "obsidian"
    "inkscape"
    "prusaslicer"
  ];
  onActivation = {
    autoUpdate = true;   # brew update on darwin-rebuild switch
    upgrade = true;      # brew upgrade on switch
    cleanup = "zap";     # remove anything not declared (optional)
  };
}
