{ config, pkgs, ... }:
{
  services.minecraft-servers.servers.proxy = {
    enable = true;
    jvmOpts = "-Xmx1G -Xms1G";
    package = pkgs.velocity-server;
    whitelist = import ../whitelist.nix;
    stopCommand = "end";
    files = {
      "velocity.toml".text = ''
        config-version = "2.5"
        bind = "0.0.0.0:25565"
        motd = "0x0D Network"
        online-mode = true
        player-info-forwarding-mode = "legacy"

        [servers]
        survival01 = "localhost:25571"
        try = ["survival01"]

        [forced-hosts]
      '';
    };
  };
}
