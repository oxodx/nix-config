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

  composeContent = pkgs.writeText "docker-compose.yml" ''
    networks:
      minecraft-network:
        driver: bridge    
        ipam:
          config:
            - subnet: 172.18.0.0/16

    services:
      lazymc:
        image: ghcr.io/joesturge/lazymc-docker-proxy:latest
        networks:
          minecraft-network:
            ipv4_address: 172.18.0.2
        restart: unless-stopped
        volumes:
          - /var/run/docker.sock:/var/run/docker.sock:ro
          - ${dataDir}:/server:ro
        ports:
          - "25565:25565"
        environment:
          - LAZYMC_DEBUG=true
          - LAZYMC_GROUP=mc

      mc:
        image: itzg/minecraft-server:java21
        pull_policy: daily
        networks:
          minecraft-network:
            ipv4_address: 172.18.0.3
        labels:
          - "lazymc.enabled=true"
          - "lazymc.group=mc"
          - lazymc.server.address=mc:25565
        restart: "no"
        tty: true
        stdin_open: true
        environment:
          DIFFICULTY: "3"
          ENABLE_WHITELIST: "true"
          EULA: "TRUE"
          MANAGEMENT_SERVER_ENABLED: "false"
          MEMORY: "2048M"
          OPS: "0x0D_\njaydon30"
          SIMULATION_DISTANCE: "6"
          TYPE: "PAPER"
          USE_MEOWICE_FLAGS: "true"
          VERSION: "1.21.11"
          VIEW_DISTANCE: "8"
          WHITELIST: "0x0D_\njaydon30"
        user: "${toString uid}:${toString uid}"
        volumes:
          - ${dataDir}:/data
  '';
in
{
  users.groups.${user} = { };
  users.users.${user} = {
    group = user;
    home = dataDir;
    isSystemUser = true;
    uid = uid;
    extraGroups = [ "docker" ]; # Add to docker group
  };

  # Create the compose file
  systemd.tmpfiles.rules = [
    "d /data/apps/minecraft        0755 ${user} ${user} - -"
    "d ${dataDir}                  0755 ${user} ${user} - -"
    "Z /data/apps/minecraft        0755 ${user} ${user} - -"
    "Z ${dataDir}                  0755 ${user} ${user} - -"
    "f ${dataDir}/docker-compose.yml 0644 ${user} ${user} - ${composeContent}"
  ];

  # Disable any existing lazymc systemd service
  systemd.services.lazymc = lib.mkForce { };

  systemd.services.minecraft = {
    description = "Minecraft Docker Compose";
    after = [
      "network-online.target"
      "docker.service"
      "systemd-tmpfiles-setup.service"
    ];
    requires = [ "docker.service" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "forking";
      RemainAfterExit = true;
      User = user;
      Group = user;
      WorkingDirectory = dataDir;
      ExecStart = "${pkgs.writeShellScript "minecraft-start" ''
        set -e
        cd ${dataDir}
        ${pkgs.docker-compose}/bin/docker-compose -f ${dataDir}/docker-compose.yml up -d --no-start
        ${pkgs.docker-compose}/bin/docker-compose -f ${dataDir}/docker-compose.yml start lazymc
        # Wait for lazymc to be ready
        sleep 5
      ''}";
      ExecStop = "${pkgs.docker-compose}/bin/docker-compose -f ${dataDir}/docker-compose.yml down";
      ExecReload = "${pkgs.docker-compose}/bin/docker-compose -f ${dataDir}/docker-compose.yml restart lazymc";
      Restart = "on-failure";
      RestartSec = "10s";
      StartLimitIntervalSec = "60s";
      StartLimitBurst = "3";
    };
  };

  # disable the old oci-container units if still present
  virtualisation.oci-containers.containers = lib.mkForce { };
}
