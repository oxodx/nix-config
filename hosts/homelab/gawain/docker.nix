{...}: {
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
        adguardhome = {
          image = "adguard/adguardhome:latest";
          volumes = [
            "/srv/adguardhome/conf:/opt/adguardhome/conf"
            "/srv/adguardhome/work:/opt/adguardhome/work"
          ];
          extraOptions = ["--network=host"];
        };
        caddy = {
          image = "caddy:2-alpine";
          volumes = [
            "/srv/caddy/certs:/certs"
            "/srv/caddy/config:/config"
            "/srv/caddy/data:/data"
            "/srv/caddy/Caddyfile:/etc/caddy/Caddyfile:ro"
          ];
          ports = ["80:80" "443:443" "443:443/udp"];
        };
        dashy = {
          image = "lissy93/dashy:latest";
          volumes = ["/srv/dashy:/app/user-data"];
          ports = ["8080:8080"];
          extraOptions = ["--user=1000:1000"];
        };
        beszel = {
          image = "henrygd/beszel:latest";
          environment = {
            APP_URL = "https://beszel.oxod.home";
            USER_EMAIL = "me@oxod.nl";
          };
          environmentFiles = ["/var/lib/gawain/beszel.env"];
          volumes = ["/data/compose/beszel/beszel_data:/beszel_data"];
          ports = ["8090:8090"];
          cmd = ["serve" "--http=0.0.0.0:8090"];
        };
        beszel-agent = {
          image = "henrygd/beszel-agent:latest";
          environment = {
            HUB_URL = "http://192.168.1.41:8090";
            LISTEN = "45876";
          };
          environmentFiles = ["/var/lib/gawain/beszel-agent.env"];
          volumes = [
            "/data/compose/beszel-agent/data:/var/lib/beszel-agent"
            "/var/run/docker.sock:/var/run/docker.sock:ro"
          ];
          extraOptions = ["--network=host"];
        };
        portainer-agent = {
          image = "portainer/agent:2.45.1";
          volumes = [
            "/:/host"
            "/var/run/docker.sock:/var/run/docker.sock"
            "/var/lib/docker/volumes:/var/lib/docker/volumes"
          ];
          ports = ["9001:9001"];
        };
      };
    };
  };

  users.users.oxod.extraGroups = ["docker"];
  networking.firewall = {
    allowedTCPPorts = [53 80 443 3000 8080 8090 9001 45876];
    allowedUDPPorts = [53 443];
  };
  systemd.tmpfiles.rules = [
    "d /data 0755 root root -"
    "d /srv 0755 root root -"
    "d /var/lib/gawain 0700 root root -"
  ];
}
