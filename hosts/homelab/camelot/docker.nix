{pkgs, ...}: let
  commonEnvironment = {
    PGID = "0";
    PUID = "0";
    TZ = "Europe/Amsterdam";
  };
  vpnNetwork = {
    dependsOn = ["gluetun"];
    extraOptions = ["--network=container:gluetun"];
  };
in {
  virtualisation = {
    docker = {
      enable = true;
      enableOnBoot = true;
      autoPrune.enable = true;
      logDriver = "journald";
    };
    oci-containers = {
      backend = "docker";
      containers = {
        gluetun = {
          image = "qmcgaw/gluetun:latest";
          environment =
            commonEnvironment
            // {
              FIREWALL_OUTBOUND_SUBNETS = "192.168.1.0/24,172.16.0.0/12";
              WIREGUARD_ADDRESSES = "10.66.24.93/32,fc00:bbbb:bbbb:bb01::3:185c/128";
              VPN_SERVICE_PROVIDER = "mullvad";
              VPN_TYPE = "wireguard";
            };
          environmentFiles = ["/var/lib/camelot/gluetun.env"];
          volumes = ["/srv/gluetun:/gluetun"];
          ports = ["6881:6881/tcp" "6881:6881/udp" "8888:8080/tcp" "9117:9117/tcp" "9696:9696/tcp"];
          extraOptions = ["--cap-add=NET_ADMIN" "--device=/dev/net/tun:/dev/net/tun"];
        };
        decluttarr = {
          image = "ghcr.io/manimatter/decluttarr:latest";
          environment =
            commonEnvironment
            // {
              DECLUTTARR_CRON = ''"*/15 * * * *"'';
              REQUESTS_CA_BUNDLE = "/certs/ca-bundle.crt";
            };
          volumes = [
            "/srv/ssl/ca-decluttarr.crt:/certs/ca-bundle.crt:ro"
            "/mnt/media:/data"
            "/srv/decluttarr:/app/config"
          ];
          cmd = ["python" "main.py"];
        };
        sonarr = {
          image = "lscr.io/linuxserver/sonarr:latest";
          environment = commonEnvironment;
          volumes = [
            "/srv/ssl/ca-sonarr.crt:/etc/ssl/certs/ca-certificates.crt:ro"
            "/srv/sonarr:/config"
            "/mnt/media:/data"
          ];
          ports = ["8989:8989"];
        };
        radarr = {
          image = "lscr.io/linuxserver/radarr:latest";
          environment = commonEnvironment;
          volumes = [
            "/srv/ssl/ca-radarr.crt:/etc/ssl/certs/ca-certificates.crt:ro"
            "/srv/radarr:/config"
            "/mnt/media:/data"
          ];
          ports = ["7878:7878"];
        };
        jackett =
          vpnNetwork
          // {
            image = "lscr.io/linuxserver/jackett:latest";
            environment = commonEnvironment;
            volumes = [
              "/srv/ssl/ca-jackett.crt:/etc/ssl/certs/ca-certificates.crt:ro"
              "/srv/jackett:/config"
              "/mnt/media:/data"
            ];
          };
        prowlarr =
          vpnNetwork
          // {
            image = "lscr.io/linuxserver/prowlarr:latest";
            environment = commonEnvironment;
            volumes = [
              "/srv/ssl/ca-prowlarr.crt:/etc/ssl/certs/ca-certificates.crt:ro"
              "/srv/prowlarr:/config"
            ];
          };
        bazarr = {
          image = "lscr.io/linuxserver/bazarr:latest";
          environment = commonEnvironment;
          volumes = [
            "/srv/ssl/ca-bazarr.crt:/etc/ssl/certs/ca-certificates.crt:ro"
            "/srv/bazarr:/config"
            "/mnt/media:/data"
          ];
          ports = ["6767:6767"];
        };
        jellyfin = {
          image = "lscr.io/linuxserver/jellyfin:latest";
          environment = commonEnvironment;
          volumes = [
            "/srv/ssl/ca-jellyfin.crt:/etc/ssl/certs/ca-certificates.crt:ro"
            "/srv/jellyfin:/config"
            "/mnt/media:/data"
          ];
          ports = ["7359:7359/udp" "8096:8096"];
          extraOptions = ["--device=/dev/dri/renderD128:/dev/dri/renderD128" "--group-add=993"];
        };
        profilarr = {
          image = "ghcr.io/dictionarry-hub/profilarr:latest";
          environment =
            commonEnvironment
            // {
              ORIGIN = "https://profilarr.oxod.home";
              PORT = "6868";
            };
          volumes = ["/srv/profilarr:/config"];
          ports = ["6868:6868"];
        };
        flaresolverr =
          vpnNetwork
          // {
            image = "ghcr.io/flaresolverr/flaresolverr:latest";
            environment = {
              CAPTCHA_SOLVER = "none";
              LOG_HTML = "false";
              LOG_LEVEL = "info";
              TZ = "Europe/Amsterdam";
            };
            volumes = ["/srv/flaresolverr:/config"];
          };
        qbittorrent =
          vpnNetwork
          // {
            image = "lscr.io/linuxserver/qbittorrent:latest";
            environment = commonEnvironment;
            volumes = ["/srv/qbittorrent:/config" "/mnt/media:/data"];
          };
        seerr = {
          image = "ghcr.io/seerr-team/seerr:latest";
          environment =
            commonEnvironment
            // {
              NODE_EXTRA_CA_CERTS = "/certs/caddy-root.crt";
              PORT = "5055";
            };
          volumes = [
            "/srv/ssl/caddy-root.crt:/certs/caddy-root.crt:ro"
            "/srv/seerr:/app/config"
          ];
          ports = ["5055:5055"];
          cmd = ["npm" "start"];
          extraOptions = ["--init" "--user=node:node"];
        };
        beszel-agent = {
          image = "henrygd/beszel-agent:latest";
          environment = {
            HUB_URL = "http://192.168.1.41:8090";
            LISTEN = "45876";
          };
          environmentFiles = ["/var/lib/camelot/beszel-agent.env"];
          volumes = [
            "/data/compose/beszel-agent/data:/var/lib/beszel-agent"
            "/mnt/media/.beszel:/extra-filesystems/media__Media:ro"
            "/var/run/docker.sock:/var/run/docker.sock:ro"
          ];
          extraOptions = ["--network=host"];
        };
        portainer-agent = {
          image = "portainer/agent:2.45.1";
          volumes = [
            "/var/run/docker.sock:/var/run/docker.sock"
            "/var/lib/docker/volumes:/var/lib/docker/volumes"
            "/:/host"
          ];
          ports = ["9001:9001"];
        };
      };
    };
  };

  users.users.oxod.extraGroups = ["docker"];
  networking.firewall = {
    allowedTCPPorts = [5055 6767 6868 6881 7878 8096 8888 8989 9001 9117 9696 45876];
    allowedUDPPorts = [6881 7359];
  };
  systemd.tmpfiles.rules = [
    "d /data 0755 root root -"
    "d /opt/containers 0755 root root -"
    "d /srv 0755 root root -"
    "d /var/lib/camelot 0700 root root -"
    "d /mnt/media/.beszel 0755 root root -"
  ];
}
