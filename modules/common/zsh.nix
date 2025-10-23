{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    defaultKeymap = "viins";
    dotDir = "${config.xdg.configHome}/zsh";

    # Disable home-manager's default compinit since we run it manually in initContent
    enableCompletion = false;

    plugins = [
      {
        name = "zsh-autosuggestions";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-autosuggestions";
          rev = "v0.7.0";
          sha256 = "sha256-KLUYpUu4DHRumQZ3w59m9aTW6TBKMCXl2UcKi4uMd7w=";
        };
      }
      {
        name = "fast-syntax-highlighting";
        src = pkgs.fetchFromGitHub {
          owner = "zdharma-continuum";
          repo = "fast-syntax-highlighting";
          rev = "v1.55";
          sha256 = "sha256-DWVFBoICroKaKgByLmDEo4O+xo6eA8YO792g8t8R7kA=";
        };
      }
      {
        name = "zsh-completions";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-completions";
          rev = "0.35.0";
          sha256 = "sha256-GFHlZjIHUWwyeVoCpszgn4AmLPSSE8UVNfRmisnhkpg=";
        };
      }
    ];

    # Environment variables and key bindings
    initContent = ''
      # XDG Base Directory Specification
      export XDG_CONFIG_HOME=''${XDG_CONFIG_HOME:-$HOME/.config}
      export XDG_CACHE_HOME=''${XDG_CACHE_HOME:-$HOME/.cache}
      export XDG_DATA_HOME=''${XDG_DATA_HOME:-$HOME/.local/share}
      export XDG_STATE_HOME=''${XDG_STATE_HOME:-$HOME/.local/state}
      export XDG_RUNTIME_DIR=''${XDG_RUNTIME_DIR:-$HOME/.xdg}

      # Create XDG directories if they don't exist
      for xdgdir in XDG_{CONFIG,CACHE,DATA,STATE}_HOME XDG_RUNTIME_DIR; do
        [[ -e ''${(P)xdgdir} ]] || mkdir -p ''${(P)xdgdir}
      done

      # Default applications
      export BROWSER="open"
      export EDITOR="nvim"
      export VISUAL="nvim"
      export PAGER="less"

      # Less configuration
      export LESS="''${LESS:--g -i -M -R -S -w -z-4}"

      # Faster ESC key response for vi-mode
      export KEYTIMEOUT=1

      # Allow backspacing past insert start in vi insert mode
      bindkey -M viins '^?' backward-delete-char
      bindkey -M viins '^H' backward-delete-char

      # q in vi command mode pushes current line to buffer
      bindkey -M vicmd "q" push-line

      # Load edit-command-line widget (accessible via execute-named-cmd)
      autoload -Uz edit-command-line
      zle -N edit-command-line

      # Cursor shape changes for vi mode (requires terminal support, e.g., via tmux overrides)
      zle-keymap-select() {
        if [[ $KEYMAP == vicmd ]]; then
          # Blinking block for command mode
          echo -ne '\e[1 q'
        else
          # Blinking bar for insert mode
          echo -ne '\e[5 q'
        fi
      }
      zle -N zle-keymap-select

      zle-line-init() {
        # Ensure initial cursor is set for insert mode
        echo -ne '\e[5 q'
      }
      zle -N zle-line-init

      # Shift+Up/Down for history search with current input
      bindkey '^[[1;2A' history-beginning-search-backward
      bindkey '^[[1;2B' history-beginning-search-forward

      # Completion configuration -- we never rebuild, rebuilding happens through home-manager
      autoload -Uz compinit
      compinit -C

      # Load menu selection module
      zmodload zsh/complist

      # Case-insensitive completion
      zstyle ':completion:*' matcher-list \
        'm:{a-z}={A-Z}'

      # Show completion list without cycling/selection
      setopt NO_AUTO_MENU
      setopt NO_MENU_COMPLETE
      setopt AUTO_LIST

      # Include hidden files in completion
      _comp_options+=(globdots)

      # Group matches and describe
      zstyle ':completion:*:matches' group 'yes'
      zstyle ':completion:*:options' description 'yes'
      zstyle ':completion:*:options' auto-description '%d'
      zstyle ':completion:*:corrections' format ' %F{red}-- %d (errors: %e) --%f'
      zstyle ':completion:*:corrections' force-list always
      zstyle ':completion:*:descriptions' format ' %F{purple}-- %d --%f'
      zstyle ':completion:*:messages' format ' %F{green} -- %d --%f'
      zstyle ':completion:*:warnings' format ' %F{yellow}-- no matches found --%f'
      zstyle ':completion:*' format ' %F{blue}-- %d --%f'
      zstyle ':completion:*' group-name '''
      zstyle ':completion:*' verbose yes

      # Use LS_COLORS for file completion
      zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}

      # Multi-column display (top-to-bottom, then left-to-right)
      zstyle ':completion:*' list-packed yes

      # Show 3 lines per group max
      zstyle ':completion:*' list-max-items 9


      # Aliases
      alias ez='eza -la'
      alias aid='aider --api-key xai="$(security find-generic-password -w -s "x.ai" -a "grok-api")"'
      alias act='DOCKER_HOST="$(docker context inspect colima --format "{{(index .Endpoints \"docker\").Host}}")" act'  # colima support

      # Empty prompt enter behavior
      magic-enter() {
        # Only trigger magic behavior if buffer is truly empty (no multi-line input)
        if [[ -z $BUFFER ]] && [[ -z $PREBUFFER ]]; then
          LBUFFER="eza -lah; git status -sb"
          zle .accept-line
        else
          zle .accept-line
        fi
      }
      zle -N accept-line magic-enter
    '';
  };
}
