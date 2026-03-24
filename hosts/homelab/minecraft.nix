{ pkgs, lib, ... }:
let
  serverPort = 25566;
  publicPort = 25565;

  lazymcConfig = pkgs.writeText "lazymc.toml" ''
    [public]
    address = "0.0.0.0:${toString publicPort}"

    [server]
    command = "systemctl start minecraft-server"
    address = "127.0.0.1:${toString serverPort}"
    directory = "/data/apps/minecraft/mc-1"
    stop_method = "rcon"
    wake_on_start = false
    wake_on_crash = true

    [rcon]
    enabled = true
    port = 25575
    password = "changeme"

    [time]
    sleep_after = 60
  '';
in
{
  services.minecraft-server = {
    enable = true;
    eula = true;
    openFirewall = false;
    declarative = true;
    package = pkgs.papermc;
    dataDir = "/data/apps/minecraft/mc-1";
    serverProperties = {
      gamemode = "survival";
      difficulty = "hard";
      simulation-distance = 10;
      white-list = true;
      allow-cheats = true;
      server-port = serverPort;
      enable-rcon = true;
      "rcon.port" = 25575;
      "rcon.password" = "changeme";
    };
    whitelist = {
      "0x0D_" = "ef9ebb67-034c-4520-a700-6c67a3d63bb1";
      "jaydon30" = "52566ea2-67eb-4266-8a9a-ad10ca6ec0df";
    };
    jvmOpts = "-Xms4092M -Xmx4092M -XX:+UseG1GC";
  };

  # Don't auto-start MC — lazymc controls it
  systemd.services.minecraft-server = {
    wantedBy = lib.mkForce [ ];
    serviceConfig.Restart = lib.mkForce "no";
  };

  systemd.services.lazymc = {
    description = "lazymc - wake Minecraft on connect, sleep when idle";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    # needs to call systemctl start minecraft-server
    path = [ pkgs.systemd ];
    serviceConfig = {
      ExecStart = "${pkgs.lazymc}/bin/lazymc start --config ${lazymcConfig}";
      Restart = "always";
      RestartSec = "5s";
    };
  };

  networking.firewall.allowedTCPPorts = [ publicPort ];
}
