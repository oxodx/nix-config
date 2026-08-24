{ pkgs, ... }:
let
  vars = import ./_variables.nix;
  vUser = vars.services.jellyfin.user;
  vGroup = vars.services.jellyfin.group;
  vLibUser = vars.libraryOwner.user;
  vLibGroup = vars.libraryOwner.group;

  enable = true;
  package = pkgs.jellyfin;
  stateDir = "${vars.dirs.state}/jellyfin";
  libDir = "${vars.dirs.media}/library";
  openFirewall = true;
in
{
  systemd.tmpfiles.rules = [
    "d '${stateDir}' 				0700 ${vUser} root - -"
    "d '${stateDir}/log' 		0700 ${vUser} root - -"
    "d '${stateDir}/cache' 	0700 ${vUser} root - -"
    "d '${stateDir}/config' 0700 ${vUser} root - -"

    "d '${libDir}' 					  0775 ${vLibUser} ${vLibGroup} - -"
    "d '${libDir}/shows' 		  0775 ${vLibUser} ${vLibGroup} - -"
    "d '${libDir}/movies' 	  0775 ${vLibUser} ${vLibGroup} - -"
    "d '${libDir}/music' 		  0775 ${vLibUser} ${vLibGroup} - -"
    "d '${libDir}/books' 		  0775 ${vLibUser} ${vLibGroup} - -"
    "d '${libDir}/audiobooks' 0775 ${vLibUser} ${vLibGroup} - -"
  ];

  # Always prioritise Jellyfin IO
  systemd.services.jellyfin.serviceConfig.IOSchedulingPriority = 0;

  services.jellyfin = {
    inherit
      enable
      package
      openFirewall
      ;

    user = vUser;
    group = vGroup;

    dataDir = stateDir;
    logDir = "${stateDir}/log";
    cacheDir = "${stateDir}/cache";
    configDir = "${stateDir}/config";

    hardwareAcceleration.enable = true;
    hardwareAcceleration.device = "/dev/dri/renderD128";
  };

  users = {
    groups.${vGroup}.gid = vars.gids.${vGroup};
    users.${vUser} = {
      isSystemUser = true;
      group = vGroup;
      uid = vars.uids.${vUser};
      extraGroups = [
        "video"
        "render"
      ];
    };
  };
}
