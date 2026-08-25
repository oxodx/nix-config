{
  pkgs,
  lib,
  ...
}: let
  vars = import ./_variables.nix;
  vUser = vars.services.radarr.user;
  vGroup = vars.services.radarr.group;
  vLibUser = vars.libraryOwner.user;
  vLibGroup = vars.libraryOwner.group;

  enable = true;
  package = pkgs.radarr;
  stateDir = "${vars.dirs.state}/radarr";
  libDir = "${vars.dirs.media}/library";
  openFirewall = true;
  port = 8989;
in {
  systemd.tmpfiles.rules = [
    "d '${stateDir}' 			0700 ${vUser} root - -"
    "d '${libDir}' 				2775 ${vLibUser} ${vLibGroup} - -"
    "d '${libDir}/movies' 2775 ${vLibUser} ${vLibGroup} - -"
  ];

  services.radarr = {
    inherit
      enable
      package
      openFirewall
      ;

    user = vUser;
    group = vGroup;

    settings.server.port = port;
    dataDir = stateDir;
  };

  # Set UMask to 0002 so directories are created with group write permission (775)
  # This allows other services in the media group (like Jellyfin) to modify files
  systemd.services.radarr.serviceConfig.UMask = lib.mkForce "0002";

  users = {
    groups.${vGroup}.gid = vars.gids.${vGroup};
    users.${vUser} = {
      isSystemUser = true;
      group = vGroup;
      uid = vars.uids.${vUser};
    };
  };
}
