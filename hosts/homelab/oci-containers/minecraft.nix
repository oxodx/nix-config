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
    image = "ghcr.io/joesturge/lazymc-docker-proxy:latest";
    volumes = [
      "${dataDir}:/server:ro"
      "/var/run/docker.sock:/var/run/docker.sock:ro"
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
    # lazymc manages start/stop, so don't auto-restart
    extraOptions = [
      "--network-alias=mc"
      "--network=minecraft_default"
      "--no-healthcheck"
      "--restart=no"
      # lazymc-docker-proxy discovers this container via these labels
      "--label=lazymc.enabled=true"
      "--label=lazymc.group=mc"
      "--label=lazymc.server.address=mc:25565"
      "--label=lazymc.server.directory=/server"
      "--label=lazymc.public.version=1.21.1"
      "--label=lazymc.public.protocol=767"
      "--label=lazymc.time.sleep_after=300"
      "--label=lazymc.server.wake_whitelist=true"
    ];
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
    log-driver = "journald";
  };

  systemd.services.init-minecraft-network = {
    description = "Create minecraft_default docker network";
    after = [
      "network.target"
      "docker.service"
    ];
    requires = [ "docker.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = pkgs.writeShellScript "init-minecraft-network" ''
        ${pkgs.docker}/bin/docker network inspect minecraft_default >/dev/null 2>&1 || \
        ${pkgs.docker}/bin/docker network create minecraft_default
      '';
    };
  };

  # Make both containers wait for the network
  systemd.services.docker-minecraft-mc.after = [ "init-minecraft-network.service" ];
  systemd.services.docker-minecraft-lazymc.after = [ "init-minecraft-network.service" ];
  systemd.services.docker-minecraft-mc.requires = [ "init-minecraft-network.service" ];
  systemd.services.docker-minecraft-lazymc.requires = [ "init-minecraft-network.service" ];
}
