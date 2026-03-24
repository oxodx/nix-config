{
  lib,
  mylib,
  ...
}:
{
  imports = mylib.scanPaths ./.;

  # Bind mount /var/lib/containers to /data/apps/podman
  fileSystems."/var/lib/containers" = {
    device = "/data/apps/podman";
    options = [ "bind" ];
  };

  # Ensure the directory exists before mounting
  systemd.tmpfiles.rules = [
    "d /data/apps/podman 0755 root root -"
  ];

  virtualisation = {
    docker.enable = lib.mkForce false;
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
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
