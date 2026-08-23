{
  pkgs,
  mylib,
  ...
}: let
  storage = {
    media = "/mnt/media";
    state = "/var/lib";
    cache = "/var/cache";
  };

  uids.media = 999;
  gids.media = 196;
in {
  imports = mylib.scanPaths ./.;

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [8080];
  };

  hardware.graphics = {
    extraPackages = with pkgs; [
      intel-media-driver
      intel-vaapi-driver
      libva-vdpau-driver
      libvpl
    ];
  };

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "i965";
  };

  systemd.tmpfiles.rules = [
    "d ${storage.media} 0775 media media -"
    "d ${storage.media}/downloads 0775 media media -"

    "d ${storage.state}/gluetun 0755 root root -"
    "d ${storage.state}/qbittorrent 0755 media media -"
    "d ${storage.state}/qbittorrent/config 0755 media media -"
    "d ${storage.state}/sonarr 0755 media media -"
    "d ${storage.state}/radarr 0755 media media -"
    "d ${storage.state}/prowlarr 0755 media media -"
  ];

  users.groups.media.gid = gids.media;
  users.users.media = {
    isSystemUser = true;
    uid = uids.media;
    group = "media";
    createHome = false;
    extraGroups = ["video" "render"];
  };

  services = {
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
        SERVER_COUNTRIES = "Sweden";
        FIREWALL_OUTBOUND_SUBNETS = "192.168.1.0/24";
      };
    };

    qbittorrent = {
      image = "linuxserver/qbittorrent:latest";
      dependsOn = ["gluetun"];
      extraOptions = ["--network=container:gluetun"];
      environment = {
        PUID = toString uids.media;
        PGID = toString gids.media;
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
        PUID = toString uids.media;
        PGID = toString gids.media;
        TZ = "Europe/Amsterdam";
      };
      volumes = [
        "${storage.state}/prowlarr:/config"
      ];
    };
  };
}
