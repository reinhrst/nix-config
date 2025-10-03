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

      # Make sure prefix is sent to programs
      bind Space send-prefix
    '';
  };
}
