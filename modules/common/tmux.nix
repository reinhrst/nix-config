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

    # Minimal delay for escape key (fast for vim, but allows escape sequences)
    escapeTime = 10;

    # Enable true color support
    terminal = "tmux-256color";

    # Typing scrolls to bottom
    extraConfig = ''
      # Vi keys in copy mode
      set-window-option -g mode-keys vi

      # Enable RGB color support
      set-option -ga terminal-overrides ",*256col*:Tc"

      # Allow cursor shape changes (Ss = set cursor style, Se = reset cursor style)
      set-option -ga terminal-overrides ',*:Ss=\E[%p1%d q:Se=\E[2 q'

      # Status bar at top with Snazzy theme colors
      set-option -g status-position top
      set-option -g status-style "bg=#282a36,fg=#ff6ac1"
      set-option -g status-left ""
      set-option -g status-right ""
      set-option -g window-status-format " #I:#W "
      set-option -g window-status-current-format " #I:#W "
      set-option -g window-status-current-style "bg=#282a36,fg=#5af78e,bold"
      set-option -g pane-border-style "fg=#57c7ff"
      set-option -g pane-active-border-style "fg=#5af78e"

      # Cursor in copy mode (reverse video block)
      set-option -g mode-style "bg=#f1fa8c,fg=#282a36"

      # Mouse click on status bar to switch windows
      set-option -g mouse on

      # Mouse selection doesn't auto-copy, stays until cleared (like Ghostty)
      unbind -T copy-mode MouseDragEnd1Pane
      unbind -T copy-mode-vi MouseDragEnd1Pane

      # Double-click selects word but doesn't copy
      bind-key -T root DoubleClick1Pane select-pane \; copy-mode -M \; send-keys -X select-word
      bind-key -T copy-mode DoubleClick1Pane select-pane \; send-keys -X select-word

      # Triple-click selects line but doesn't copy
      bind-key -T root TripleClick1Pane select-pane \; copy-mode -M \; send-keys -X select-line
      bind-key -T copy-mode TripleClick1Pane select-pane \; send-keys -X select-line

      # Key bindings (using M- for Option/Alt, which is cmd in Ghostty with proper config)
      # Note: In Ghostty, we'll configure cmd to send Option sequences
      # IMPORTANT: Any M- keybindings below must be added to modules/desktop/ghostty.nix

      # cmd-t: new window in home directory
      bind-key -n M-t new-window -c ~

      # cmd-shift-t: new window in current directory (right after current tab)
      bind-key -n M-T new-window -a -c "#{pane_current_path}"

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

      # cmd-c: copy to system clipboard (uses yank plugin)
      bind-key -T copy-mode-vi M-c send-keys -X copy-pipe-and-cancel "pbcopy"
      bind-key -T copy-mode M-c send-keys -X copy-pipe-and-cancel "pbcopy"

      # cmd-v: paste from system clipboard
      bind-key -n M-v run-shell "pbpaste | tmux load-buffer - && tmux paste-buffer"

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
          bind-key -n M-A run-shell "tmux capture-pane -p -S - | tail -r | awk '/❯/{if(found) exit; found=1; next} found' | tail -r | pbcopy"
        '';
      }
    ];
  };
}
