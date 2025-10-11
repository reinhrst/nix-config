{ config, lib, pkgs, ... }:

let
  version = "0.0.33";

  grokSrc = pkgs.fetchFromGitHub {
    owner = "superagent-ai";
    repo  = "grok-cli";
    rev   = "@vibe-kit/grok-cli@${version}";
    sha256 = "sha256-4+be/H/LEMNxNTYHW7L4wDIKPm09yuYo4r08ZeBiJ4w=";
  };

  grokPkg = pkgs.buildNpmPackage {
    pname = "grok-cli";
    inherit version;

    src = grokSrc;

    npmDepsHash = "sha256-Yl51fCnI3soQ4sGBg4dr+kVak8zYEkMTgyUKDaRK6N0=";

    nodejs = pkgs.nodejs;

    meta = with pkgs.lib; {
      description = "@vibe-kit/grok-cli";
      homepage = "https://github.com/superagent-ai/grok-cli";
      platforms = platforms.unix;
    };
  };
in
{
  home.packages = [ grokPkg ];

  xdg.configFile."grok-cli/.keep".text = "";
}

