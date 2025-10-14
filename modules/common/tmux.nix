{ config, pkgs, ... }:

{
  programs.tmux = {
    enable = true;

    # Change leader to Ctrl-a
    prefix = "C-a";

    # Start window numbering at 1
    baseIndex = 1;

    # Scrollback buffer
    historyLimit = 1000000;

    # Enable mouse support
    mouse = true;

    # Typing scrolls to bottom
    extraConfig = ''
      # Status bar at top with macOS-style appearance
      set-option -g status-position top
      set-option -g status-style "bg=#282a36,fg=#f8f8f2"
      set-option -g status-left ""
      set-option -g status-right ""
      set-option -g window-status-format " #I:#W "
      set-option -g window-status-current-format " #I:#W "
      set-option -g window-status-current-style "bg=#44475a,fg=#f8f8f2,bold"
      set-option -g pane-border-style "fg=#44475a"
      set-option -g pane-active-border-style "fg=#6272a4"

      # Mouse click on status bar to switch windows
      set-option -g mouse on

      # Key bindings (using M- for Option/Alt, which is cmd in Ghostty with proper config)
      # Note: In Ghostty, we'll configure cmd to send Option sequences
      # IMPORTANT: Any M- keybindings below must be added to modules/desktop/ghostty.nix

      # cmd-t: new window in home directory
      bind-key -n M-t new-window -c ~

      # cmd-shift-t: new window in current directory
      bind-key -n M-T new-window -c "#{pane_current_path}"

      # cmd-{: previous window
      bind-key -n 'M-{' previous-window

      # cmd-}: next window
      bind-key -n 'M-}' next-window

      # cmd-shift-left: move window left
      bind-key -n M-S-Left swap-window -t -1\; select-window -t -1

      # cmd-shift-right: move window right
      bind-key -n M-S-Right swap-window -t +1\; select-window -t +1

      # cmd-1 through cmd-9: select window
      bind-key -n M-1 select-window -t 1
      bind-key -n M-2 select-window -t 2
      bind-key -n M-3 select-window -t 3
      bind-key -n M-4 select-window -t 4
      bind-key -n M-5 select-window -t 5
      bind-key -n M-6 select-window -t 6
      bind-key -n M-7 select-window -t 7
      bind-key -n M-8 select-window -t 8
      bind-key -n M-9 select-window -t 9

      # cmd-shift-up: scroll to previous prompt
      bind-key -n M-Up copy-mode\; send-keys -X search-backward "❯"

      # cmd-shift-down: scroll to next prompt
      bind-key -n M-Down copy-mode\; send-keys -X search-forward "❯"

      # cmd-c: copy (in copy mode)
      bind-key -n M-c copy-mode\; send-keys -X copy-selection-and-cancel

      # cmd-v: paste
      bind-key -n M-v paste-buffer

      # Typing exits copy mode and scrolls to bottom
      bind-key -T copy-mode-vi v send-keys -X cancel
    '';

    # Plugins
    plugins = with pkgs.tmuxPlugins; [
      yank
      {
        plugin = pkgs.tmuxPlugins.extrakto;
        extraConfig = ''
          # cmd-shift-a: copy last command output
          bind-key -n M-A run-shell "tmux capture-pane -p -S - | tail -r | sed -n '/❯/,/❯/p' | tail -r | head -n -1 | pbcopy"
        '';
      }
    ];
  };
}
