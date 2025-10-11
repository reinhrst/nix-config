{ config, pkgs, ... }:

{
  programs.atuin = {
    enable = true;
    enableZshIntegration = false; # Disable automatic integration
    settings = {
      # Disable all default key bindings
      keymap_mode = "emacs";
      # Set default filter mode to global
      filter_mode = "global";
      filter_mode_shell_up_key_binding = "global";
    };
  };

  # Manual atuin integration with Ctrl-R and directory-scoped autosuggestions
  programs.zsh.initContent = ''
    # Initialize atuin without any key bindings
    export ATUIN_NOBIND="true"
    eval "$(${pkgs.atuin}/bin/atuin init zsh)"

    # Custom strategy for directory-scoped atuin suggestions
    _zsh_autosuggest_strategy_atuin_directory() {
      typeset -g suggestion
      suggestion=$(${pkgs.atuin}/bin/atuin search --cwd "$PWD" --cmd-only --limit 1 --search-mode prefix "$1" 2>/dev/null)
    }

    # Configure zsh-autosuggestions to use directory-scoped atuin
    ZSH_AUTOSUGGEST_STRATEGY=(atuin_directory)

    # Wrapper for atuin search that clears autosuggestions
    _atuin_search_wrapper() {
      _zsh_autosuggest_clear
      zle _atuin_search_widget
      _zsh_autosuggest_fetch
    }
    zle -N _atuin_search_wrapper

    # Only bind Ctrl-R for atuin search with wrapper
    bindkey '^r' _atuin_search_wrapper
  '';
}
