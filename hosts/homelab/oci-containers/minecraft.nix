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

  composeFile = pkgs.writeText "docker-compose.yml" ''
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
          - ${dataDir}:/server:ro
          - /var/run/docker.sock:/var/run/docker.sock:ro
        ports:
          - "25565:25565"

      mc:
        image: itzg/minecraft-server:java21
        pull_policy: daily
        networks:
          minecraft-network:
            ipv4_address: 172.18.0.3
        labels:
          - lazymc.enabled=true
          - lazymc.group=mc
          - lazymc.server.address=mc:25565
        tty: true
        stdin_open: true
        restart: no
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
  };

  systemd.tmpfiles.rules = [
    "d /data/apps/minecraft        0755 ${user} ${user} -"
    "d ${dataDir}                  0755 ${user} ${user} -"
    "Z /data/apps/minecraft        0755 ${user} ${user} -"
    "Z ${dataDir}                  0755 ${user} ${user} -"
  ];

  systemd.services.minecraft = {
    description = "Minecraft Docker Compose";
    after = [
      "network-online.target"
      "docker.service"
    ];
    requires = [ "docker.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "forking";
      RemainAfterExit = true;
      WorkingDirectory = dataDir;
      ExecStart = "${pkgs.docker-compose}/bin/docker-compose -f ${composeFile} up -d --no-start && ${pkgs.docker-compose}/bin/docker-compose -f ${composeFile} start lazymc";
      ExecStop = "${pkgs.docker-compose}/bin/docker-compose -f ${composeFile} down";
      Restart = "on-failure";
    };
  };

  # disable the old oci-container units if still present
  virtualisation.oci-containers.containers = lib.mkForce { };
}
