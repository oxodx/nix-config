{
  lib,
  config,
  ...
}:
let
  user = "minecraft";
  dataDir = "/data/apps/minecraft/mc-1";
in
{
  imports = [ ./default.nix ];

  systemd.tmpfiles.rules = [
    "d ${dataDir} 0755 ${user} ${user}"
  ];

  virtualisation.oci-containers.containers."minecraft-mc" = {
    image = "itzg/minecraft-server:latest";
    environment = {
      "DIFFICULTY" = "3";
      "ENABLE_WHITELIST" = "true";
      "EULA" = "TRUE";
      "MANAGEMENT_SERVER_ENABLED" = "false";
      "MEMORY" = "2048M";
      "OPS" = "0x0D_
  jaydon30";
      "SIMULATION_DISTANCE" = "6";
      "TYPE" = "PAPER";
      "USE_MEOWICE_FLAGS" = "true";
      "VERSION" = "1.21.11";
      "VIEW_DISTANCE" = "8";
      "WHITELIST" = "0x0D_
  jaydon30";
    };
    volumes = [
      "/data/apps/minecraft/mc-1:/data:rw"
    ];
    ports = [
      "25565:25565/tcp"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=mc"
      "--network=minecraft_default"
      "--no-healthcheck"
    ];
  };

  systemd.services.create-minecraft-network = {
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = "podman network inspect minecraft_default || podman network create minecraft_default";
    wantedBy = [ "multi-user.target" ];
  };
}
