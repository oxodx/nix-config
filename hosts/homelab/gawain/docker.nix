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
    allowedTCPPorts = [9001 45876];
  };
  systemd.tmpfiles.rules = [
    "d /data 0755 root root -"
    "d /var/lib/gawain 0700 root root -"
  ];
}
