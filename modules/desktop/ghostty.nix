{ config, pkgs, ... }:

{
  # Ghostty configuration
  # (installed via Homebrew in darwin.nix, configured here)
  xdg.configFile."ghostty/config".text = ''
    # Start tmux by default
    command = ${pkgs.tmux}/bin/tmux new-session -A -s main

    theme = Snazzy

    # Font configuration
    font-family = "JetBrainsMono Nerd Font"
    font-size = 13
    font-feature = -calt, -liga, -dlig

    # Window management (send Option sequences for tmux)
    keybind = super+t=text:\x1bt
    keybind = super+shift+t=text:\x1bT
    keybind = super+left_bracket=text:\x1b[
    keybind = super+right_bracket=text:\x1b]
    keybind = super+shift+left_bracket=text:\x1b{
    keybind = super+shift+right_bracket=text:\x1b}

    # Scrolling
    keybind = super+shift+up=text:\x1b[1;2A
    keybind = super+shift+down=text:\x1b[1;2B

    # Copy/paste
    keybind = super+shift+a=text:\x1bA
    keybind = super+c=text:\x1bc
    keybind = super+v=text:\x1bv

    # Window selection
    keybind = super+one=text:\x1b1
    keybind = super+two=text:\x1b2
    keybind = super+three=text:\x1b3
    keybind = super+four=text:\x1b4
    keybind = super+five=text:\x1b5
    keybind = super+six=text:\x1b6
    keybind = super+seven=text:\x1b7
    keybind = super+eight=text:\x1b8
    keybind = super+nine=text:\x1b9
  '';
}
