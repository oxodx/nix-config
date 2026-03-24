{
  lib,
  mylib,
  ...
}:
{
  imports = mylib.scanPaths ./.;

  virtualisation = {
    docker = {
      enable = true;
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
