# Single source of truth for unfree packages permitted across the flake:
# consumed by the linux pkgs instance and by every home-manager config, so the
# allow-list is defined once instead of scattered across flake.nix/home.nix.
#
# Usage: lib.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) (import ./modules/allow-unfree.nix);
[
  "claude-code"
]
