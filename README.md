Repo contains my nix-darwin and home-manger setup

In order to install:

- Install `nix` like described [here][1] -- right now it seems to be using Determinate Systems installed but choosing the non-determinate install option
- Clone this repo and run: `sudo darwin-rebuild switch --flake .#trc` (or, first time: `sudo nix --extra-experimental-features 'nix-command flakes' run nix-darwin/master#darwin-rebuild -- switch --flake .#trc`)
- I [seems like nix-darwin cannot set default shell yet][2], so do so manually: `chsh -s /etc/profiles/per-user/reinoud/bin/zsh`

For everyday updates, run `make`

## Secrets

This repo is public, so **never commit real secrets**. The config is secret-free
today. If you ever need to store credentials (API keys, atuin sync key, etc.):

- Use [sops-nix](https://github.com/Mic92/sops-nix) or [agenix](https://github.com/ryantm/agenix) to manage them encrypted in the tree.
- A `gitleaks` scan runs on every push/PR (`.github/workflows/secrets.yml`, config in `.gitleaks.toml`) and can be run locally with `pre-commit install` + `git commit`, or ad hoc via `nix run nixpkgs#gitleaks -- detect`.
- Silence a false positive with a targeted `[allowlist]` entry — never by disabling a rule.

[1]: https://github.com/nix-darwin/nix-darwin
[2]: https://discourse.nixos.org/t/how-to-set-desired-shell-with-nix-darwin/49826
