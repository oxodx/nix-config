{
  lib,
  mylib,
  ...
}:
{
  imports = mylib.scanPaths ./.;

  # Bind mount /var/lib/containers to /data/apps/docker
  fileSystems."/var/lib/containers" = {
    device = "/data/apps/docker";
    options = [ "bind" ];
  };

  # Ensure the directory exists before mounting
  systemd.tmpfiles.rules = [
    "d /data/apps/docker 0755 root root -"
  ];

  virtualisation = {
    docker.enable = lib.mkForce true;
    oci-containers.backend = "docker";
  };
}
