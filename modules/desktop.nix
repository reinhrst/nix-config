{ config, pkgs, ... }:

{
  # Ghostty configuration
  # (installed via Homebrew in darwin.nix, configured here)
  xdg.configFile."ghostty/config".text = ''
    # Shell integration
    shell-integration = zsh

    # Snazzy theme colors (original iTerm2 Snazzy)
    background = 282c34
    foreground = f0f0f0

    palette = 0=#000000
    palette = 1=#ff5c57
    palette = 2=#5af78e
    palette = 3=#f3f99d
    palette = 4=#57c7ff
    palette = 5=#ff6ac1
    palette = 6=#9aedfe
    palette = 7=#f0f0f0
    palette = 8=#686868
    palette = 9=#ff5c57
    palette = 10=#5af78e
    palette = 11=#f3f99d
    palette = 12=#57c7ff
    palette = 13=#ff6ac1
    palette = 14=#9aedfe
    palette = 15=#f0f0f0

    # Font configuration
    font-family = "JetBrainsMono Nerd Font"
    font-size = 13

    window-show-tab-bar = always
    clipboard-paste-protection = true

    # Keybindings
    keybind = super+z=undo

  '';
}
