{ pkgs }:

{
  # Desktop/GUI applications

  # Packages from nixpkgs (referenced by home.nix)
  packages = with pkgs; [
    utm
  ];

  # Apps installed via Homebrew (referenced by darwin.nix)
  casks = [
    "ghostty"
  ];
}
