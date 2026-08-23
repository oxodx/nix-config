let
  storage = {
    media = "/mnt/media";
    state = "/var/lib";
    cache = "/var/cache";
  };

  mediaUid = 999;
  mediaGid = 999;
in {
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [8080];
  };

  systemd.tmpfiles.rules = [
    "d ${storage.media} 0775 media media -"
    "d ${storage.media}/downloads 0775 media media -"
    "d ${storage.media}/tv 0775 media media -"
    "d ${storage.media}/movies 0775 media media -"

    "d ${storage.state}/gluetun 0755 root root -"
    "d ${storage.state}/qbittorrent 0755 media media -"
    "d ${storage.state}/qbittorrent/config 0755 media media -"
    "d ${storage.state}/sonarr 0755 media media -"
    "d ${storage.state}/radarr 0755 media media -"
    "d ${storage.state}/prowlarr 0755 media media -"
    "d ${storage.state}/jellyfin 0755 media media -"
    "Z ${storage.state}/jellyfin 0755 media media -"
    "d ${storage.cache}/jellyfin 0755 media media -"
    "Z ${storage.cache}/jellyfin 0755 media media -"
  ];

  users.groups.media = {
    gid = mediaGid;
  };
  users.users.media = {
    isSystemUser = true;
    uid = mediaUid;
    group = "media";
    createHome = false;
  };

  services = {
    jellyfin = {
      enable = true;
      openFirewall = true;
      user = "media";
      group = "media";
    };

    seerr = {
      enable = true;
      openFirewall = true;
    };

    sonarr = {
      enable = true;
      openFirewall = true;
      user = "media";
      group = "media";
    };

    radarr = {
      enable = true;
      openFirewall = true;
      user = "media";
      group = "media";
    };
  };

  virtualisation.oci-containers.containers = {
    gluetun = {
      image = "qmcgaw/gluetun:latest";
      extraOptions = ["--cap-add=NET_ADMIN"];
      ports = [
        "8080:8080" # qBittorrent Web UI
        "9696:9696" # Prowlarr Web UI
        "8191:8191" # FlareSolverr API Port
        "6881:6881" # Torrent TCP
        "6881:6881/udp" # Torrent UDP
      ];
      volumes = [
        "${storage.state}/gluetun:/gluetun"
      ];
      environmentFiles = ["/root/secrets/mullvad.env"];
      environment = {
        VPN_SERVICE_PROVIDER = "mullvad";
        VPN_TYPE = "wireguard";
        SERVER_COUNTRIES = "Germany";
      };
    };

    qbittorrent = {
      image = "linuxserver/qbittorrent:latest";
      dependsOn = ["gluetun"];
      extraOptions = ["--network=container:gluetun"];
      environment = {
        PUID = toString mediaUid;
        PGID = toString mediaGid;
        TZ = "Europe/Amsterdam";
        WEBUI_PORT = "8080";
      };
      volumes = [
        "${storage.state}/qbittorrent/config:/config"
        "${storage.media}/downloads:/downloads"
      ];
    };

    prowlarr = {
      image = "linuxserver/prowlarr:latest";
      dependsOn = ["gluetun"];
      extraOptions = ["--network=container:gluetun"];
      environment = {
        PUID = toString mediaUid;
        PGID = toString mediaGid;
        TZ = "Europe/Amsterdam";
      };
      volumes = [
        "${storage.state}/prowlarr:/config"
      ];
    };

    flaresolverr = {
      image = "ghcr.io/flaresolverr/flaresolverr:latest";
      dependsOn = ["gluetun"];
      extraOptions = ["--network=container:gluetun"];
      environment = {
        TZ = "Europe/Amsterdam";
        LOG_LEVEL = "info";
      };
    };
  };
}
