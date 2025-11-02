{ config, pkgs, ... }:

{
  programs.tmux = {
    enable = true;

    # Change leader to Ctrl-space
    prefix = "C-space";

    # Start window numbering at 1
    baseIndex = 1;

    # Scrollback buffer
    historyLimit = 1000000;

    # Enable mouse support
    mouse = true;

    # Enable true color support
    terminal = "tmux-256color";

    # Typing scrolls to bottom
    extraConfig = ''
      set -g default-shell ${pkgs.zsh}/bin/zsh
      set -g default-command "${pkgs.zsh}/bin/zsh -l"

      ${builtins.readFile ./tmux.conf}
    '';

    # Plugins
    plugins = with pkgs.tmuxPlugins; [
      yank
      extrakto
      fzf-tmux-url
      sensible
      (mkTmuxPlugin {
        pluginName = "tmux-picker";
        version = "unstable-2019-02-04";
        src = pkgs.fetchFromGitHub {
          owner = "pawel-wiejacha";
          repo = "tmux-picker";
          rev = "827845f89044fbfb3cd73905f000340bbbda663a";
          sha256 = "sha256-XXB1XmIYhHzDL4JneH1MS3uUolk+QID21IY9xDuwhQI=";
        };
      })
      (mkTmuxPlugin {
        pluginName = "tmux-fzf-maccy";
        version = "unstable-2025-01-07";
        src = pkgs.fetchFromGitHub {
          owner = "junegunn";
          repo = "tmux-fzf-maccy";
          rev = "6df60d88285178768bc262e2966aeb5e987173d0";
          sha256 = "sha256-4vgYIgWXBiVz5BUIal45mpUjb1RyT7Imq04N0g4Q+Ss=";
        };
      })
    ];
  };
}
