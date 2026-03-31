{ pkgs, ... }:
let
  serverVersion = "1_21_11";
in
{
  services.minecraft-servers.servers.survival01 = {
    enable = true;
    enableReload = true;

    package = pkgs.paperServers."paper-${serverVersion}";
    jvmOpts = ((import ../../aikar-flags.nix) "2G") + "-Dpaper.disableChannelLimit=true";
    whitelist = import ../whitelist.nix;
    operators = import ../operators.nix;
    serverProperties = {
      server-port = 25571;
      white-list = true;
      online-mode = false;
      max-tick-time = -1;
      network-compression-threshold = 256;
      simulation-distance = 4;
      view-distance = 8;
    };

    symlinks = import ./plugins.nix;
    files = import ./files.nix;
  };
}
