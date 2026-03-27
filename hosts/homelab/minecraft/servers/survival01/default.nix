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
    whitelist = import ./whitelist.nix;
    serverProperties = {
      server-port = 25581;
      online-mode = false;
      max-tick-time = -1;
    };

    symlinks = {
      "plugins/ViaVersion.jar" = pkgs.fetchurl rec {
        pname = "ViaVersion";
        version = "5.7.2";
        url = "https://github.com/ViaVersion/${pname}/releases/download/${version}/${pname}-${version}.jar";
        hash = "sha256:4430a127f6cb21d7a52ec6a07a5dcc43ba235acc062c86330619b8de1d4958fd";
      };
      "plugins/ViaBackwards.jar" = pkgs.fetchurl rec {
        pname = "ViaBackwards";
        version = "5.7.2";
        url = "https://github.com/ViaVersion/${pname}/releases/download/${version}/${pname}-${version}.jar";
        hash = "sha256:cbf4ce4dc132b1bcccc2abb9626ed18bb1bd116c9300657543458241b01000f7";
      };
    };

    files = {
      "plugins/ViaVersion/config.yml".value = {
        checkforupdates = false;
      };
    };

    lazymc = {
      enable = true;
      config = {
        public.address = "0.0.0.0:25571";
      };
    };
  };
}
