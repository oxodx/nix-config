{ pkgs, lib, ... }:
let
  lazymcConfig = pkgs.writeText "lazymc.toml" ''
    [public]
    address = "0.0.0.0:25565"

    [server]
    address = "127.0.0.1:25566"
    directory = "/data/apps/minecraft/mc-1"
    start_command = "systemctl start minecraft-server"
    stop_method = "rcon"
    wake_on_start = false
    wake_on_crash = true

    [time]
    sleep_after = 600

    [rcon]
    enabled = true
    port = 25575
    password = "lazymc_rcon_secret"
  '';
in
{
  services.minecraft-server = {
    enable = true;
    eula = true;
    openFirewall = false; # lazymc owns 25565, MC is internal only
    declarative = true;
    package = pkgs.papermc;
    dataDir = "/data/apps/minecraft/mc-1";
    serverProperties = {
      gamemode = "survival";
      difficulty = "hard";
      simulation-distance = 10;
      white-list = true;
      allow-cheats = true;
      server-port = 25566; # moved off public port
      enable-rcon = true;
      "rcon.port" = 25575;
      "rcon.password" = "lazymc_rcon_secret";
    };
    whitelist = {
      "0x0D_" = "ef9ebb67-034c-4520-a700-6c67a3d63bb1";
      "jaydon30" = "52566ea2-67eb-4266-8a9a-ad10ca6ec0df";
    };
    jvmOpts = "-Xms4092M -Xmx4092M -XX:+UseG1GC";
  };

  # Don't auto-start MC — lazymc will start it on demand
  systemd.services.minecraft-server.wantedBy = lib.mkForce [ ];

  systemd.services.lazymc = {
    description = "lazymc - wake Minecraft on connect, sleep when idle";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.lazymc}/bin/lazymc start --config ${lazymcConfig}";
      Restart = "always";
      RestartSec = "5s";
    };
  };

  networking.firewall.allowedTCPPorts = [ 25565 ];
}
