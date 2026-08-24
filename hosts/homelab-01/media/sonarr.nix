{
  pkgs,
  lib,
  ...
}: let
  vars = import ./variables.nix;
  vUser = vars.services.sonarr.user;
  vGroup = vars.services.sonarr.group;
  vLibUser = vars.libraryOwner.user;
  vLibGroup = vars.libraryOwner.group;

  enable = true;
  package = pkgs.sonarr;
  stateDir = "${vars.dirs.state}/sonarr";
  libDir = "${vars.dirs.media}/library";
  openFirewall = true;
  port = 8989;
in {
  systemd.tmpfiles.rules = [
    "d '${stateDir}' 			0700 ${vUser} root - -"
    "d '${libDir}' 				2775 ${vLibUser} ${vLibGroup} - -"
    "d '${libDir}/shows'  2775 ${vLibUser} ${vLibGroup} - -"
  ];

  sonarr = {
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
  systemd.services.sonarr.serviceConfig.UMask = lib.mkForce "0002";

  users = {
    groups.${vGroup}.gid = vars.gids.${vGroup};
    users.${vUser} = {
      isSystemUser = true;
      group = vGroup;
      uid = vars.uids.${vUser};
    };
  };
}
