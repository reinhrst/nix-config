{ config, pkgs, ... }:

{
  programs.atuin = {
    enable = true;
    enableZshIntegration = false; # Disable automatic integration
    settings = {
      # Disable all default key bindings
      keymap_mode = "emacs";
    };
  };

  # Manual atuin integration with only Ctrl-R binding
  programs.zsh.initContent = ''
    # Initialize atuin without any key bindings
    export ATUIN_NOBIND="true"
    eval "$(${pkgs.atuin}/bin/atuin init zsh)"

    # Only bind Ctrl-R for atuin search
    bindkey '^r' _atuin_search_widget
  '';
}
