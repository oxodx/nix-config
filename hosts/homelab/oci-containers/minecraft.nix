{
  lib,
  config,
  ...
}:
let
  user = "minecraft";
  dataDir = "/data/apps/minecraft/mc-1";
  containerUid = 1000; # UID that the container runs as
  containerGid = 1000; # GID that the container runs as
in
{
  users.groups.${user} = { };
  users.users.${user} = {
    group = user;
    home = dataDir;
    isSystemUser = true;
    uid = containerUid; # Match the container's UID
    gid = containerGid; # Match the container's GID
  };

  # Create Directories
  # https://www.freedesktop.org/software/systemd/man/latest/tmpfiles.d.html#Type
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
    user = "${toString containerUid}:${toString containerGid}";
    log-driver = "journald";
    extraOptions = [
      "--network-alias=mc"
      "--network=minecraft_default"
      "--no-healthcheck"
    ];
  };
}
