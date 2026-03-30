{ config, pkgs, ... }:
let
  serversCfg = config.services.minecraft-servers.servers;
in
{
  services.minecraft-servers.servers.proxy = {
    enable = true;
    jvmOpts = "-Xmx1G -Xms1G";
    package = pkgs.velocity-server;
    stopCommand = "shutdown";
    files = {
      "velocity.toml".value = {
        "config-version" = "2.7";
        bind = "0.0.0.0:25565";
        motd = "0x0D Network";
        online-mode = true;
        "player-info-forwarding-mode" = "legacy";
        servers = {
          survival01 = "localhost:${toString serversCfg.survival01.serverProperties."server-port"}";
          try = [ "survival01" ];
        };
        "forced-hosts" = { };
      };
    };
  };
}
