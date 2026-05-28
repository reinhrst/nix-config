{ config, pkgs, lib, ... }:

let
  makeOverridesYaml = { arch, memory ? null }:
    let
      memoryStr = if memory != null then "memory: ${builtins.toString memory}\n" else "";
    in
    pkgs.writeText "overrides.yaml" ''
      arch: ${arch}
      ${memoryStr}
      hostname: ""
      kubernetes:
        k3sArgs:
          - --disable=traefik
      network:
        dnsHosts: {}
      vmType: vz
      mountInotify: true
      cpuType: ""
      mountType: virtiofs
      mounts:
        - location: /Volumes/Work
          writable: true
        - location: /tmp/colima
          writable: true
    '';

  makeMergedConfig = overridesYaml: pkgs.runCommand "colima-config.yaml" {} ''
    ${pkgs.yq-go}/bin/yq eval-all 'select(fileIndex == 0) * select(fileIndex == 1)' \
      ${pkgs.colima.src}/embedded/defaults/colima.yaml \
      ${overridesYaml} \
      > $out
  '';

  profiles = {
    default = { arch = "aarch64"; memory = 8; };
    big = { arch = "aarch64"; memory = 16; };
    x86_64 = { arch = "x86_64"; memory = 8; };
    "x86_64-big" = { arch = "x86_64"; memory = 16; };
  };
in {
  # Install Colima
  home.packages = with pkgs; [
    colima
    docker
  ];

  # Colima configuration
  xdg.configFile = lib.listToAttrs (lib.mapAttrsToList (name: cfg: {
    name = "colima/${name}/colima.yaml";
    value = { source = makeMergedConfig (makeOverridesYaml cfg); };
  }) profiles);

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
