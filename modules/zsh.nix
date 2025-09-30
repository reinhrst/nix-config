{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    defaultKeymap = "viins";
    dotDir = "${config.xdg.configHome}/zsh";
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
      {
        name = "fzf-tab";
        src = pkgs.fetchFromGitHub {
          owner = "Aloxaf";
          repo = "fzf-tab";
          rev = "v1.1.2";
          sha256 = "sha256-Qv8zAiMtrr67CbLRrFjGaPzFZcOiMVEFLg1Z+N6VMhg=";
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
      export BROWSER="''${BROWSER:-open}"
      export EDITOR="''${EDITOR:-nvim}"
      export VISUAL="''${VISUAL:-nvim}"
      export PAGER="''${PAGER:-less}"

      # Less configuration
      export LESS="''${LESS:--g -i -M -R -S -w -z-4}"

      # Faster ESC key response for vi-mode
      export KEYTIMEOUT=1

      # q in vi command mode pushes current line to buffer
      bindkey -M vicmd "q" push-line

      # Shift+Up/Down for history search with current input
      bindkey '^[[1;2A' history-beginning-search-backward
      bindkey '^[[1;2B' history-beginning-search-forward
    '';
  };
}