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

  environment.etc."stacks/minecraft/velocity.toml".text = ''
    config-version = "2.7"
    bind = "0.0.0.0:25565"
    online-mode = true
    force-key-authentication = true
    prevent-client-proxy-connections = false
    player-info-forwarding-mode = "modern"
    kick-existing-players = false
    ping-passthrough = "DISABLED"
    enable-player-address-logging = true

    [servers]
    survival01 = "mc:25577"

    [forced-hosts]

    [advanced]
    compression-threshold = 256
    compression-level = -1
    login-ratelimit = 3000
    connection-timeout = 5000
    read-timeout = 30000
    haproxy-protocol = false
    tcp-fast-open = false
    bungee-plugin-message-channel = true
    show-max-players = 500
    fail-over-on-unexpected-server-disconnect = true

    [query]
    enabled = false
    port = 25577
  '';

  environment.etc."stacks/minecraft/compose.yaml".text = ''
    services:
      proxy:
        image: itzg/mc-proxy
        environment:
          TYPE: VELOCITY
          DEBUG: "false"
          ENABLE_RCON: "true"
        ports:
          - "25565:25565"
        volumes:
          - "/etc/stacks/minecraft/velocity.toml:/config/velocity.toml:ro"
          - "${dataDir}/proxy/forwarding.secret:/config/forwarding.secret:ro"
          - "${dataDir}/proxy:/server"

      survival01:
        image: itzg/minecraft-server:latest
        tty: true
        stdin_open: true
        expose:
          - "25577"
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
          VELOCITY_FORWARDING_SECRET_FILE: "/data/forwarding.secret"
        volumes:
          - "${dataDir}/survival01:/data"
          - "${dataDir}/proxy/forwarding.secret:/data/forwarding.secret:ro"
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
      docker compose -f /etc/stacks/minecraft/compose.yaml up
    '';
    restartTriggers = [
      config.environment.etc."stacks/minecraft/compose.yaml".source
      config.environment.etc."stacks/minecraft/velocity.toml".source
    ];
  };
}
