{ pkgs, lib, ... }:
{
  # https://github.com/NixOS/nixpkgs/blob/nixos-25.11/nixos/modules/services/misc/forgejo.nix
  services.forgejo = {
    enable = true;
    user = "forgejo";
    group = "forgejo";
    stateDir = "/data/apps/forgejo";
    lfs.enable = true;
    # Enable a timer that runs forgejo dump to generate backup-files of the current forgejo database and repositories.
    dump = {
      enable = false;
      interval = "daily";
      file = "forgejo-dump";
      type = "tar.zst";
    };

    settings = {
      server = {
        HTTP_PORT = 3008;
        SSH_PORT = lib.head config.services.openssh.ports;
      };
    };
  };
}
