{ config, pkgs, ... }:

let
  # Our overrides
  overridesYaml = pkgs.writeText "colima-overrides.yaml" ''
    mounts:
      - location: /Volumes/Work
        writable: true
      - location: /tmp/colima
        writable: true
  '';

  # Merge default template with our overrides at build time
  mergedConfig = pkgs.runCommand "colima-config.yaml" {} ''
    ${pkgs.yq-go}/bin/yq eval-all 'select(fileIndex == 0) * select(fileIndex == 1)' \
      ${pkgs.colima.src}/embedded/defaults/colima.yaml \
      ${overridesYaml} \
      > $out
  '';

in {
  # Install Colima
  home.packages = with pkgs; [
    colima
    docker
  ];

  # Colima configuration
  xdg.configFile."colima/default/colima.yaml".source = mergedConfig;

  launchd.agents.colima = {
    enable = true;
    config = {
      ProgramArguments = [
        "${pkgs.colima}/bin/colima"
        "start"
        "--foreground"
        "--save-config=false"
      ];
      RunAtLoad = true;
      KeepAlive = true;
      EnvironmentVariables = {
        COLIMA_HOME = "${config.xdg.configHome}/colima";
        PATH = "${pkgs.docker}/bin:/usr/bin:/bin:/usr/sbin:/sbin";
      };
    };
  };
}
