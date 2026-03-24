{
  lib,
  config,
  pkgs,
  ...
}:
let
  user = "minecraft";
  uid = 990;
  dataDir = "/data/apps/minecraft/mc-1";

  # TODO: replace with proper secret management
  rconPassword = "changeme";

  lazymcToml = pkgs.writeText "lazymc.toml" ''
    [server]
    address = "0.0.0.0:25565"
    directory = "/data"
    start_on_join = true
    wake_on_start = true
    freeze_process = false

    [public]
    address = "0.0.0.0:25565"
    version = "1.21.1"
    protocol = 767

    [rcon]
    enabled = true
    host = "mc"
    port = 25575
    password = "${rconPassword}"

    [time]
    sleep_after = 300
  '';
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

  virtualisation.oci-containers.containers."minecraft-lazymc" = {
    image = "ghcr.io/timvisee/lazymc:latest";
    volumes = [
      "${lazymcToml}:/lazymc.toml:ro"
    ];
    ports = [
      "25565:25565/tcp"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network=minecraft_default"
      "--no-healthcheck"
    ];
  };

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
      "RCON_ENABLED" = "true";
      "RCON_PASSWORD" = rconPassword;
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
    log-driver = "journald";
    extraOptions = [
      "--network-alias=mc"
      "--network=minecraft_default"
      "--no-healthcheck"
    ];
  };
}
