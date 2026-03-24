{ pkgs, ... }:
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
    database = {
      type = "sqlite3";
      name = "forgejo";
      group = "forgejo";
      createDatabase = true;
    };
  };

  users = {
    users.forgejo = {
      home = "/var/lib/forgejo";
      useDefaultShell = true;
      group = "forgejo";
      isSystemUser = true;
    };

    groups.forgejo = { };
  };
}
