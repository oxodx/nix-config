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

  environment.etc."stacks/minecraft.yaml".text = ''
    services:
      proxy:
        image: itzg/mc-proxy
        environment:
          TYPE: VELOCITY
          DEBUG: "false"
          ENABLE_RCON: "true"
        ports:
          - "25565:25577"
        volumes:
          - "${dataDir}/proxy/velocity.toml:/config/velocity.toml:ro"
          - "${dataDir}/proxy/forwarding.secret:/config/forwarding.secret:ro"
          - "${dataDir}/proxy:/server"

      mc:
        image: itzg/minecraft-server:latest
        tty: true
        stdin_open: true
        environment:
          EULA: "TRUE"
          ONLINE_MODE: "FALSE"
          TYPE: "PAPER"
          MEMORY: "4096M"
          USE_MEOWICE_FLAGS: "true"
          TZ: "Europe/Amsterdam"
          DIFFICULTY: "3"
          SIMULATION_DISTANCE: "6"
          VIEW_DISTANCE: "8"
          SPAWN_PROTECTION: "0"
        volumes:
          - "${dataDir}/survival01:/data"
  '';

  networking.firewall = {
    enable = true;
    extraCommands = ''
      # Allow established connections
      iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

      # Rate limit new connections to Minecraft port
      # Max 3 new connections per 60 seconds per IP
      iptables -A INPUT -p tcp --dport 25565 -m state --state NEW \
        -m recent --set --name MC_CONN

      iptables -A INPUT -p tcp --dport 25565 -m state --state NEW \
        -m recent --update --seconds 60 --hitcount 4 --name MC_CONN \
        -j DROP
    '';
    extraStopCommands = ''
      iptables -D INPUT -p tcp --dport 25565 -m state --state NEW \
        -m recent --set --name MC_CONN 2>/dev/null || true

      iptables -D INPUT -p tcp --dport 25565 -m state --state NEW \
        -m recent --update --seconds 60 --hitcount 4 --name MC_CONN \
        -j DROP 2>/dev/null || true
    '';
  };

  systemd.services.minecraft = {
    wantedBy = [ "multi-user.target" ];
    after = [
      "docker.service"
      "docker.socket"
    ];
    path = [ pkgs.docker ];
    script = ''
      docker compose -f /etc/stacks/minecraft.yaml up
    '';
    restartTriggers = [
      config.environment.etc."stacks/minecraft.yaml".source
    ];
  };
}
