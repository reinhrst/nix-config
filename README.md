Repo contains my nix-darwin and home-manger setup

In order to install:

- Install `nix` like described [here][1] -- right now it seems to be using Determinate Systems installed but choosing the non-determinate install option
- Clone this repo and run: `sudo darwin-rebuild switch --flake .#mindy`
- I [seems like nix-darwin cannot set default shell yet][2], so do so manually: `chsh -s /etc/profiles/per-user/reinoud/bin/zsh`

For everyday updates, run `home-manager switch --flake .#reinoud@mindy`

[1]: https://github.com/nix-darwin/nix-darwin
[2]: https://discourse.nixos.org/t/how-to-set-desired-shell-with-nix-darwin/49826
