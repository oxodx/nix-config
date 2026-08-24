{
  pkgs,
  mylib,
  ...
}: let
  vars = import ./variables.nix;

  storage.cache = "/var/cache";
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
    "d ${vars.dirs.media} 0775 media media -"
    "d ${vars.dirs.media}/downloads 0775 media media -"

    "d ${vars.dirs.state}/gluetun 0755 root root -"
    "d ${vars.dirs.state}/qbittorrent 0755 media media -"
    "d ${vars.dirs.state}/qbittorrent/config 0755 media media -"
    "d ${vars.dirs.state}/sonarr 0755 media media -"
    "d ${vars.dirs.state}/radarr 0755 media media -"
    "d ${vars.dirs.state}/prowlarr 0755 media media -"
  ];

  users.groups.media.gid = vars.gids.media;
  users.users.media = {
    isSystemUser = true;
    uid = vars.uids.media;
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
        "${vars.dirs.state}/gluetun:/gluetun"
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
        PUID = toString vars.uids.media;
        PGID = toString vars.gids.media;
        TZ = "Europe/Amsterdam";
        WEBUI_PORT = "8080";
      };
      volumes = [
        "${vars.dirs.state}/qbittorrent/config:/config"
        "${vars.dirs.media}/downloads:/downloads"
      ];
    };

    prowlarr = {
      image = "linuxserver/prowlarr:latest";
      dependsOn = ["gluetun"];
      extraOptions = ["--network=container:gluetun"];
      environment = {
        PUID = toString vars.uids.media;
        PGID = toString vars.gids.media;
        TZ = "Europe/Amsterdam";
      };
      volumes = [
        "${vars.dirs.state}/prowlarr:/config"
      ];
    };
  };
}
