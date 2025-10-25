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

    # Minimal delay for escape key (fast for vim, but allows escape sequences)
    escapeTime = 0;

    # Enable true color support
    terminal = "tmux-256color";

    # Typing scrolls to bottom
    extraConfig = builtins.readFile ./tmux.conf;

    # Plugins
    plugins = with pkgs.tmuxPlugins; [
      yank
      {
        plugin = pkgs.tmuxPlugins.extrakto;
        extraConfig = ''
          # cmd-shift-a: copy last command output
          bind-key -n M-A run-shell "tmux capture-pane -p -S - | tail -r | awk '/❯/{if(found) exit; found=1; next} found {print}' | tail -r | pbcopy"
        '';
      }
    ];
  };
}
