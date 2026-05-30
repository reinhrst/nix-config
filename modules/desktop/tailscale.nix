{ config, lib, pkgs, ... }:
{
  services.tailscale.enable = true;

  # CLI on PATH for `tailscale serve` etc.
  environment.systemPackages = [ pkgs.tailscale ];
}
