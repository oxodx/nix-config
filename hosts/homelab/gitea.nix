{ pkgs, ... }:
{
  # https://github.com/NixOS/nixpkgs/blob/nixos-25.11/nixos/modules/services/misc/gitea.nix
  services.gitea = {
    enable = true;
    user = "gitea";
    group = "gitea";
    stateDir = "/data/apps/gitea";
    appName = "0x0D's Gitea Service";
    lfs.enable = true;
    # Enable a timer that runs gitea dump to generate backup-files of the current gitea database and repositories.
    dump = {
      enable = false;
      interval = "daily";
      file = "gitea-dump";
      type = "tar.zst";
    };
    database = {
      type = "sqlite3";
      # create a local database automatically.
      createDatabase = true;
    };
  };
}
