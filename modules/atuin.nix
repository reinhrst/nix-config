{ config, pkgs, ... }:

{
  programs.atuin = {
    enable = true;
    enableZshIntegration = false; # Disable automatic integration
    settings = {
      # Disable all default key bindings
      keymap_mode = "emacs";
      # Set default filter mode to directory
      filter_mode = "directory";
      filter_mode_shell_up_key_binding = "directory";
      inline_height = 1;
    };
  };

  # Manual atuin integration with Ctrl-R and directory-scoped autosuggestions
  programs.zsh.initContent = ''
    # Initialize atuin without any key bindings
    export ATUIN_NOBIND="true"
    eval "$(${pkgs.atuin}/bin/atuin init zsh)"

    # Only bind Ctrl-R for atuin search
    bindkey '^r' _atuin_search_widget

    # Configure zsh-autosuggestions to use atuin with directory filter
    ZSH_AUTOSUGGEST_STRATEGY=(atuin)
  '';
}
