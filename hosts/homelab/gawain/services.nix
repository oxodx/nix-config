{config, ...}: let
  domain = "oxod.home";
  camelotIp = "192.168.1.47";
  excaliburIp = "192.168.1.206";
in {
  imports = [./docker.nix];

  services = {
    adguardhome = {
      enable = true;
      host = "0.0.0.0";
      port = 3000;
      mutableSettings = true;
      settings.dns = {
        bind_hosts = ["0.0.0.0"];
        port = 53;
        bootstrap_dns = ["1.1.1.1" "9.9.9.9"];
      };
    };

    caddy = {
      enable = true;
      dataDir = "/srv/caddy";
      openFirewall = true;
      extraConfig = ''
        ${domain} {
          tls internal
          root * ${config.services.dashy.finalDrv}
          try_files {path} /index.html
          file_server
        }

        proxmox.${domain} {
          tls internal
          reverse_proxy https://192.168.1.201:8006 {
            transport http {
              tls_insecure_skip_verify
              versions 1.1
            }
          }
        }

        adguard.${domain} {
          tls internal
          reverse_proxy 127.0.0.1:3000
        }

        portainer.${domain} {
          tls internal
          reverse_proxy https://${excaliburIp}:9443 {
            transport http {
              tls_insecure_skip_verify
              versions 1.1
            }
          }
        }

        pelican.${domain} {
          tls internal
          @wings_websocket path /api/servers /api/servers/*
          handle @wings_websocket {
            reverse_proxy https://${excaliburIp}:8081 {
              transport http {
                tls_insecure_skip_verify
                versions 1.1
              }
            }
          }
          handle {
            reverse_proxy ${excaliburIp}:8080
          }
        }

        wings.${domain} {
          tls internal
          reverse_proxy https://${excaliburIp}:8081 {
            transport http {
              tls_insecure_skip_verify
              versions 1.1
            }
          }
        }

        dashy.${domain} {
          tls internal
          root * ${config.services.dashy.finalDrv}
          try_files {path} /index.html
          file_server
        }

        beszel.${domain} {
          tls internal
          request_body {
            max_size 10MB
          }
          reverse_proxy 127.0.0.1:8090 {
            transport http {
              read_timeout 360s
            }
          }
        }

        jellyfin.${domain} {
          tls internal
          reverse_proxy ${camelotIp}:8096
        }

        sonarr.${domain} {
          tls internal
          reverse_proxy ${camelotIp}:8989
        }

        radarr.${domain} {
          tls internal
          reverse_proxy ${camelotIp}:7878
        }

        bazarr.${domain} {
          tls internal
          reverse_proxy ${camelotIp}:6767
        }

        seerr.${domain} {
          tls internal
          reverse_proxy ${camelotIp}:5055
        }

        profilarr.${domain} {
          tls internal
          reverse_proxy ${camelotIp}:6868
        }

        prowlarr.${domain} {
          tls internal
          reverse_proxy ${camelotIp}:9696
        }

        jackett.${domain} {
          tls internal
          reverse_proxy ${camelotIp}:9117
        }

        qbittorrent.${domain} {
          tls internal
          reverse_proxy ${camelotIp}:8888
        }

        http://jellyfin-tv.${domain} {
          reverse_proxy ${camelotIp}:8096
        }

        http://ca.${domain} {
          root * /srv/caddy/certs/pki-public
          file_server
        }
      '';
    };

    dashy = {
      enable = true;
      settings = {
        appConfig.language = "en";
        pageInfo.title = "oxod";
        sections = [
          {
            name = "Management";
            items = [
              {
                title = "Proxmox";
                icon = "sh-proxmox-light";
                url = "https://proxmox.${domain}/";
              }
              {
                title = "Portainer";
                icon = "sh-portainer-light";
                url = "https://portainer.${domain}/";
              }
              {
                title = "Adguard Home";
                icon = "sh-adguard-home-light";
                url = "https://adguard.${domain}/";
              }
              {
                title = "Beszel";
                icon = "sh-beszel-light";
                url = "https://beszel.${domain}/";
              }
            ];
          }
          {
            name = "Media";
            items = [
              {
                title = "Jellyfin";
                icon = "sh-jellyfin-light";
                url = "https://jellyfin.${domain}/";
              }
              {
                title = "Seerr";
                icon = "sh-jellyseerr-light";
                url = "https://seerr.${domain}/";
              }
              {
                title = "Radarr";
                icon = "sh-radarr-light";
                url = "https://radarr.${domain}/";
              }
              {
                title = "Sonarr";
                icon = "sh-sonarr-light";
                url = "https://sonarr.${domain}/";
              }
              {
                title = "Bazarr";
                icon = "sh-bazarr-light";
                url = "https://bazarr.${domain}/";
              }
              {
                title = "Profilarr";
                icon = "sh-configarr-light";
                url = "https://profilarr.${domain}/";
              }
              {
                title = "qBittorrent";
                icon = "sh-qbittorrent-light";
                url = "https://qbittorrent.${domain}/";
              }
              {
                title = "Prowlarr";
                icon = "sh-prowlarr-light";
                url = "https://prowlarr.${domain}/";
              }
              {
                title = "Jackett";
                icon = "sh-jackett-light";
                url = "https://jackett.${domain}/";
              }
            ];
          }
          {
            name = "Misc";
            items = [
              {
                title = "Pelican";
                icon = "sh-pelican-panel-light";
                url = "https://pelican.${domain}/";
              }
            ];
          }
        ];
        pages = [];
      };
    };
  };

  systemd.services = {
    caddy.serviceConfig.Environment = [
      "XDG_CONFIG_HOME=/srv/caddy/config"
      "XDG_DATA_HOME=/srv/caddy/data"
    ];
  };

  networking.firewall = {
    allowedTCPPorts = [53 3000 8090];
    allowedUDPPorts = [53];
  };
}
