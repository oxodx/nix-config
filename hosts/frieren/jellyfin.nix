{ config, ... }:
let
  user = "jellyfin";
  dataDir = "/data/apps/jellyfin";
in
{
  users.groups.${user} = { };
  users.users.${user} = {
    group = user;
    home = dataDir;
    isSystemUser = true;
  };

  systemd.tmpfiles.rules = [
    "d ${dataDir} 0755 ${user} ${user}"
  ];

  services.jellyfin = {
    enable = true;
    user = user;
    group = user;
    dataDir = dataDir;
  };
}
