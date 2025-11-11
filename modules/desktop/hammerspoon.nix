{ ... }:

{
  # Hammerspoon installed through cask through nix-darwin
  home.file.".config/hammerspoon/init.lua".text = ''
    -- Custom lua config

    -- Main Hammerspoon config starts here (from repo file)
    ${builtins.readFile ./hammerspoon/init.lua}
  '';
}
