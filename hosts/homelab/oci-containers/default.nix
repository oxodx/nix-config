{
  lib,
  pkgs,
  mylib,
  ...
}:
{
  imports = mylib.scanPaths ./.;

  systemd.tmpfiles.rules = [
    "d /data/apps/docker          0755 root root -"
  ];

  virtualisation = {
    docker = {
      enable = true;
      daemon.settings = {
        data-root = "/data/apps/docker";
      };
      autoPrune = {
        enable = true;
        dates = "weekly";
        flags = [ "--all" ];
      };
    };
    podman.enable = lib.mkForce false;
    oci-containers = {
      backend = "docker";
    };
  };

  environment.systemPackages = [ pkgs.docker-compose ];
}
