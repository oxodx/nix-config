rec {
  dirs = {
    media = "/mnt/media";
    state = "/var/lib";
  };

  vpn = {
    enable = true;
    wgConf = "/root/secrets/mullvad.conf";
    accessibleFrom = [];
    vpnTestService = {
      enable = true;
      port = 58403;
    };
    openTcpPorts = [];
    openUdpPorts = [];
    proxyListenAddr = "0.0.0.0";
    exposeOnLAN = true;
  };

  libraryOwner.user = "root";
  libraryOwner.group = "media";

  uids = {
    media = 999;
    jellyfin = 146;
    sonarr = 274;
    radarr = 275;
    seerr = 262;
  };
  gids = {
    media = 196;
    seerr = 250;
  };

  services = {
    jellyfin = {
      user = "jellyfin";
      group = libraryOwner.group;
    };
    radarr = {
      user = "radarr";
      group = libraryOwner.group;
    };
    sonarr = {
      user = "sonarr";
      group = libraryOwner.group;
    };
    seerr = {
      user = "seerr";
      group = libraryOwner.group;
    };
  };
}
