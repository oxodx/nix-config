{ pkgs, ... }:
let
  serversCfg = config.services.minecraft-servers.servers;
in
{
  services.minecraft-servers.servers.proxy = {
    enable = true;
    jvmOpts = "-Xmx1G -Xms1G";
    package = pkgs.minecraftServers.velocity-server;
    whitelist = import ../whitelist.nix;
    stopCommand = "end";
    files = {
      "velocity.toml".value = {
        config-version = "2.5";
        bind = "0.0.0.0:25565";
        motd = "0x0D Network";
        online-mode = true;
        servers = {
          survival = "localhost:${toString serversCfg.survival01.lazymc.server-port}";
          try = [ "survival" ];
        };
        # It's safe to use, as long as you don't open the underlying server ports
        player-info-forwarding-mode = "legacy";
      };
    };
  };
}
