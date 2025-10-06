{ config, pkgs, ... }:

{
  # Ghostty configuration
  # (installed via Homebrew in darwin.nix, configured here)
  xdg.configFile."ghostty/config".text = ''
    # Start a unique tmux session for each tab/pane
    command = ${pkgs.tmux}/bin/tmux new-session -A -s "ghostty-$(uuidgen)"

    # Add your Ghostty configuration here
    # Example:
    # theme = "catppuccin-mocha"
    # font-family = "JetBrains Mono NL"
    # font-size = 14
  '';
}
