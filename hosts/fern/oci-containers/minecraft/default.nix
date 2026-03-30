{ config, pkgs, ... }:
let
  user = "minecraft";
  dataDir = "/data/apps/minecraft";
in
{
  users.groups.${user} = { };
  users.users.${user} = {
    group = user;
    home = dataDir;
    isSystemUser = true;
  };

  systemd.tmpfiles.rules = [
    "d ${dataDir} 0755 ${user} ${user}"
  ];

  environment.etc."${dataDir}/compose.yaml".text = ''
    services:
      mc:
        image: itzg/minecraft-server:latest
        tty: true
        stdin_open: true
        ports:
          - "25565:25565"
        environment:
          EULA: "TRUE"
          TYPE: "PAPER"
          MEMORY: "4096M"
          USE_MEOWICE_FLAGS: "true"
          TZ: "Europe/Amsterdam"
          DIFFICULTY: "3"
          SIMULATION_DISTANCE: "6"
          VIEW_DISTANCE: "8"
          SPAWN_PROTECTION: "0"
        volumes:
          - "${dataDir}:/data"
  '';

  systemd.services.minecraft = {
    wantedBy = [ "multi-user.target" ];
    after = [
      "docker.service"
      "docker.socket"
    ];
    path = [ pkgs.docker ];
    script = ''
      docker compose -f ${dataDir}/compose.yaml up
    '';
    restartTriggers = [
      config.environment.etc."${dataDir}/compose.yaml".source
    ];
  };
}
