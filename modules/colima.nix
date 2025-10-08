{ config, pkgs, ... }:

{
  # Install Colima
  home.packages = with pkgs; [
    colima
    docker
  ];

  # Colima configuration
  xdg.configFile."colima/default/colima.yaml".text = ''
    mounts:
      - location: /Volumes
        writable: true
  '';

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
      };
    };
  };
}
