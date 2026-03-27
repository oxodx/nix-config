{ config, ... }:
let
  user = "glances";
  dataDir = "/data/apps/glances";
in
{
  users.groups.${user} = { };
  users.users.${user} = {
    group = user;
    home = dataDir;
    isSystemUser = true;
  };

  # Create Directories
  # https://www.freedesktop.org/software/systemd/man/latest/tmpfiles.d.html#Type
  systemd.tmpfiles.rules = [
    "d ${dataDir} 0755 ${user} ${user}"
  ];

  # https://github.com/NixOS/nixpkgs/blob/nixos-25.11/nixos/modules/virtualisation/oci-containers.nix
  virtualisation.oci-containers.containers = {
    # check its logs via `journalctl -u podman-glances`
    glances = {
      hostname = "glances";
      image = "nicolargo/glances:latest";
      ports = [ "0.0.0.0:53350:61208" ];
      environment = {
        GLANCES_OPT = "-w";
      };
      volumes = [
        "/var/run/podman/podman.sock:/var/run/docker.sock"
        "${dataDir}:/app/data"
      ];
      autoStart = true;
    };
  };
}
