{ config, ... }:
let
  user = "kuma";
  dataDir = "/data/apps/uptime-kuma";
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
    # check its logs via `journalctl -u podman-uptime-kuma`
    uptime-kuma = {
      hostname = "uptime-kuma";
      image = "louislam/uptime-kuma:1";
      ports = [ "127.0.0.1:53350:3001" ];
      volumes = [
        "${dataDir}:/app/data"
      ];
      autoStart = true;
    };
  };
}
