{
  lib,
  config,
  ...
}:
let
  user = "minecraft";
  uid = 990;
  dataDir = "/data/apps/minecraft/mc-1";
in
{
  users.groups.${user} = { };
  users.users.${user} = {
    group = user;
    home = dataDir;
    isSystemUser = true;
    uid = uid;
  };

  systemd.tmpfiles.rules = [
    "d /data/apps/minecraft        0755 ${user} ${user} -"
    "d ${dataDir}                  0755 ${user} ${user} -"
    "Z /data/apps/minecraft        0755 ${user} ${user} -"
    "Z ${dataDir}                  0755 ${user} ${user} -"
  ];

  virtualisation.oci-containers.containers."minecraft-mc" = {
    image = "itzg/minecraft-server:latest";
    user = "${toString uid}:${toString uid}";
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
      "${dataDir}:/data:rw"
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
}
