{ config, pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    prefix = "C-Space";
    keyMode = "vi";

    extraConfig = ''
      # Split panes with | and -
      bind | split-window -h
      bind - split-window -v
      unbind '"'
      unbind %

      # Navigate splits with Ctrl+hjkl (without prefix)
      bind -n C-h select-pane -L
      bind -n C-j select-pane -D
      bind -n C-k select-pane -U
      bind -n C-l select-pane -R

      # Quit tmux when last window closes
      set-option -g destroy-unattached on

      # Make sure prefix is sent to programs
      bind Space send-prefix
    '';
  };
}
