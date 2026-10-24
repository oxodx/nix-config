{pkgs, ...}: let
  docker = "${pkgs.docker}/bin/docker";
  pelicanNetwork = {
    extraOptions = ["--network=pelican"];
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
        pelican-database =
          pelicanNetwork
          // {
            image = "mariadb:10.11";
            environment = {
              MYSQL_DATABASE = "panel";
              MYSQL_USER = "pelican";
            };
            environmentFiles = ["/var/lib/excalibur/pelican-database.env"];
            volumes = ["/srv/pelican/db:/var/lib/mysql"];
            cmd = ["--default-authentication-plugin=mysql_native_password"];
            extraOptions = pelicanNetwork.extraOptions ++ ["--network-alias=database"];
          };
        pelican-cache =
          pelicanNetwork
          // {
            image = "redis:alpine";
            cmd = ["redis-server"];
            extraOptions = pelicanNetwork.extraOptions ++ ["--network-alias=cache"];
          };
        pelican-panel =
          pelicanNetwork
          // {
            image = "ghcr.io/pelican/panel:latest";
            dependsOn = ["pelican-cache" "pelican-database"];
            environment = {
              APP_DEBUG = "false";
              APP_ENV = "production";
              APP_INSTALLED = "true";
              APP_URL = "https://pelican.oxod.home";
              BEHIND_PROXY = "true";
              CACHE_STORE = "redis";
              DB_CONNECTION = "mariadb";
              DB_DATABASE = "panel";
              DB_HOST = "database";
              DB_PORT = "3306";
              DB_USERNAME = "pelican";
              LE_EMAIL = "me@oxod.nl";
              MAIL_DRIVER = "log";
              QUEUE_CONNECTION = "redis";
              REDIS_HOST = "cache";
              SESSION_DRIVER = "redis";
              TRUSTED_PROXIES = "192.168.1.41,172.17.0.1,172.16.0.0/12";
              XDG_DATA_HOME = "/pelican-data";
            };
            environmentFiles = ["/var/lib/excalibur/pelican-panel.env"];
            volumes = [
              "/srv/pelican/panel-data:/pelican-data"
              "/srv/pelican/certs/panel-ca.crt:/certs/panel-ca.crt:ro"
              "/srv/pelican/plugins:/var/www/html/plugins"
              "/srv/pelican/panel-logs:/var/www/html/storage/logs"
              "/srv/pelican/certs/99-daemon-ca.ini:/usr/local/etc/php/conf.d/99-daemon-ca.ini:ro"
            ];
            ports = ["8080:80"];
          };
        pelican-wings =
          pelicanNetwork
          // {
            image = "ghcr.io/pelican/wings:latest";
            environment = {
              NODE_EXTRA_CA_CERTS = "/usr/local/share/ca/caddy-root.crt";
              SSL_CERT_FILE = "/usr/local/share/ca/caddy-root.crt";
              TZ = "UTC";
              WINGS_GID = "988";
              WINGS_UID = "988";
              WINGS_USERNAME = "pelican";
            };
            volumes = [
              "/srv/pelican-wings/config/letsencrypt:/etc/letsencrypt"
              "/srv/pelican-wings/config:/etc/pelican"
              "/tmp/pelican:/tmp/pelican"
              "/srv/pelican-wings/server-data:/var/lib/pelican"
              "/srv/pelican-wings/logs:/var/log/pelican"
              "/var/run/docker.sock:/var/run/docker.sock"
              "/srv/caddy/certs/root.crt:/usr/local/share/ca/caddy-root.crt:ro"
            ];
            ports = ["2022:2022" "8081:8081"];
          };
        portainer = {
          image = "portainer/portainer-ce:sts";
          volumes = [
            "/srv/portainer:/data"
            "/var/run/docker.sock:/var/run/docker.sock"
          ];
          ports = ["8000:8000" "9443:9443"];
        };
        beszel-agent = {
          image = "henrygd/beszel-agent:latest";
          environment = {
            HUB_URL = "http://192.168.1.41:8090";
            LISTEN = "45876";
          };
          environmentFiles = ["/var/lib/excalibur/beszel-agent.env"];
          volumes = [
            "/data/compose/beszel-agent/data:/var/lib/beszel-agent"
            "/var/run/docker.sock:/var/run/docker.sock:ro"
          ];
          extraOptions = ["--network=host"];
        };
      };
    };
  };

  users.users.oxod.extraGroups = ["docker"];
  networking.firewall.allowedTCPPorts = [2022 45876 8000 8080 8081 9443];

  systemd = {
    tmpfiles.rules = [
      "d /data 0755 root root -"
      "d /srv 0755 root root -"
      "d /srv/pelican/plugins 0755 root root -"
      "d /srv/portainer 0755 root root -"
      "d /var/lib/excalibur 0700 root root -"
      "L+ /var/lib/pelican - - - - /srv/pelican-wings/server-data"
    ];
    services = {
      pelican-network = {
        description = "Pelican Docker network";
        wantedBy = ["multi-user.target"];
        requires = ["docker.service"];
        after = ["docker.service"];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };
        script = ''
          ${docker} network inspect pelican >/dev/null 2>&1 \
            || ${docker} network create --driver bridge pelican
        '';
      };
      docker-pelican-database = {
        requires = ["pelican-network.service"];
        after = ["pelican-network.service"];
      };
      docker-pelican-cache = {
        requires = ["pelican-network.service"];
        after = ["pelican-network.service"];
      };
      docker-pelican-panel = {
        requires = ["pelican-network.service"];
        after = ["pelican-network.service"];
      };
      docker-pelican-wings = {
        requires = ["pelican-network.service"];
        after = ["pelican-network.service"];
      };
    };
  };
}
