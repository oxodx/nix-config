{
  lib,
  mylib,
  ...
}:
{
  imports = mylib.scanPaths ./.;

  systemd.tmpfiles.rules = [
    "d /data/apps/podman          0755 root root -"
  ];

  virtualisation = {
    docker.enable = lib.mkForce false;
    podman = {
      enable = true;

      # Create a docker alias for podman
      dockerCompat = true;

      # Required for containers under podman-compose to be able to talk to each other
      defaultNetwork.settings.dns_enabled = true;

      # Periodically prune Podman resources
      autoPrune = {
        enable = true;
        dates = "weekly";
        flags = [ "--all" ];
      };

      # Configure the storage location
      containersConf = {
        engine = {
          volume_path = "/data/apps/podman/volumes";
        };
      };
    };

    oci-containers = {
      backend = "podman";
    };
  };
}
