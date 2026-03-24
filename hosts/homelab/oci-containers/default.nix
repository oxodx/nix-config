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
      extraSettings = {
        containers = {
          storage = {
            graphroot = "/data/apps/podman";
          };
        };
      };
      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;
      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
      # Periodically prune Podman resources
      autoPrune = {
        enable = true;
        dates = "weekly";
        flags = [ "--all" ];
      };
    };

    oci-containers = {
      backend = "podman";
    };
  };
}
