{ pkgs, ... }:
let
  dir = "stacks/minecraft";
in
{
  environment.etc."${dir}/compose.yaml".text = ''
    services:
      router:
        image: itzg/mc-router
        environment:
          IN_DOCKER: true
          AUTO_SCALE_DOWN: true
          AUTO_SCALE_UP: true
          AUTO_SCALE_DOWN_AFTER: 1m
          AUTO_SCALE_ASLEEP_MOTD: "Server is asleep. Join again to wake it up!"
        ports:
          - "25565:25565"
        volumes:
          - /var/run/docker.sock:/var/run/docker.sock:ro

      survival01:
        image: itzg/minecraft-server:latest
        tty: true
        stdin_open: true
        restart: "no"
        environment:
          EULA: "TRUE"
          TYPE: "PAPER"
          VERSION: "1.21.11"
          MEMORY: "2048M"
          ONLINE_MODE: "false"
          USE_MEOWICE_FLAGS: "true"
          ENABLE_AUTOSTOP: "TRUE"
          TZ: "Europe/Amsterdam"
          DIFFICULTY: "3"
          SIMULATION_DISTANCE: "4"
          VIEW_DISTANCE: "8"
          SPAWN_PROTECTION: "0"
          ENABLE_WHITELIST: "true"
          ENABLE_AUTOSTOP: "TRUE"
          PLUGINS: |-
            https://ci.lucko.me/job/spark/524/artifact/spark-bukkit/build/libs/spark-1.10.172-bukkit.jar
            https://cdn.modrinth.com/data/fALzjamp/versions/P3y2MXnd/Chunky-Bukkit-1.4.40.jar
            https://github.com/ViaVersion/ViaVersion/releases/download/5.8.0/ViaVersion-5.8.0.jar
            https://github.com/ViaVersion/ViaBackwards/releases/download/5.8.0/ViaBackwards-5.8.0.jar
          MANAGEMENT_SERVER_ENABLED: "false"
        volumes:
          - "/srv/minecraft/survival01:/data"
        labels:
          mc-router.host: "survival01.fern"
          mc-router.default: "true"
  '';

  systemd.services.minecraft = {
    wantedBy = [ "multi-user.target" ];
    after = [
      "docker.service"
      "docker.socket"
    ];
    path = [ pkgs.docker ];
    script = ''
      docker compose -f /etc/${dir}/compose.yaml up
    '';
    restartTriggers = [
      "/etc/${dir}/compose.yaml"
    ];
  };
}
