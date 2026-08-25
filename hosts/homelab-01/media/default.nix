{
  lib,
  pkgs,
  mylib,
  ...
}: let
  vars = import ./_variables.nix;
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

  vpnNamespaces.wg = lib.mkIf vars.vpn.enable {
    enable = true;
    openVPNPorts = lib.optional (vars.vpn.vpnTestService.port != null) {
      port = vars.vpn.vpnTestService.port;
      protocol = "tcp";
    };
    accessibleFrom =
      (
        if vars.vpn.exposeOnLAN
        then [
          "10.0.0.0/8"
          "172.16.0.0/12"
          "192.168.0.0/16"
        ]
        else ["127.0.0.1"]
      )
      ++ vars.vpn.accessibleFrom;
    wireguardConfigFile = vars.vpn.wgConf;
  };

  systemd.services.vpn-test-service = lib.mkIf vars.vpn.vpnTestService.enable {
    enable = true;

    vpnConfinement = {
      enable = true;
      vpnNamespace = "wg";
    };

    script = let
      vpn-test = pkgs.writeShellApplication {
        name = "vpn-test";
        runtimeInputs = with pkgs; [util-linux unixtools.ping coreutils curl bash libressl netcat-gnu openresolv dig];
        text =
          ''
            cd "$(mktemp -d)"

            # DNS information
            dig google.com

            # Print resolv.conf
            echo "/etc/resolv.conf contains:"
            cat /etc/resolv.conf

            # Check if resolvconf is available
            if command -v resolvconf >/dev/null 2>&1; then
              # Query resolvconf
              echo "resolvconf output:"
              resolvconf -l
              echo ""
            fi

            # Get ip
            echo "Getting IP:"
            curl -s ipinfo.io

            echo -ne "DNS leak test:"
            curl -s https://raw.githubusercontent.com/macvk/dnsleaktest/b03ab54d574adbe322ca48cbcb0523be720ad38d/dnsleaktest.sh -o dnsleaktest.sh
            chmod +x dnsleaktest.sh
            ./dnsleaktest.sh
          ''
          + (
            if vars.vpn.vpnTestService.port != null
            then ''
              echo "starting netcat on port ${toString vars.vpn.vpnTestService.port}:"
              nc -vnlp ${toString vars.vpn.vpnTestService.port}
            ''
            else ""
          );
      };
    in "${vpn-test}/bin/vpn-test";
  };
}
