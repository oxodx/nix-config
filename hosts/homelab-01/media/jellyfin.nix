{pkgs, ...}: let
  enable = true;
  package = pkgs.jellyfin;
  stateDir = "/var/lib/jellyfin";
  mediaDir = "/mnt/media";
  openFirewall = true;

  uids.jellyfin = 146;
  gids.media = 196;

  libraryOwner = {
    user = "root";
    group = "media";
  };
  jellyfin = {
    user = "jellyfin";
    group = libraryOwner.group;
  };
in {
  users = {
    groups.${jellyfin.group}.gid = gids.${jellyfin.group};
    users.${jellyfin.user} = {
      isSystemUser = true;
      group = "media";
      uid = uids.${jellyfin.user};
      extraGroups = [
        "video"
        "render"
      ];
    };
  };

  systemd.tmpfiles.rules = [
    "d '${stateDir}' 				0700 ${jellyfin.user} root - -"
    "d '${stateDir}/log' 		0700 ${jellyfin.user} root - -"
    "d '${stateDir}/cache' 	0700 ${jellyfin.user} root - -"
    "d '${stateDir}/config' 0700 ${jellyfin.user} root - -"

    "d '${mediaDir}/library' 						0755 ${libraryOwner.user} ${libraryOwner.group} - -"
    "d '${mediaDir}/library/shows' 			0755 ${libraryOwner.user} ${libraryOwner.group} - -"
    "d '${mediaDir}/library/movies' 		0755 ${libraryOwner.user} ${libraryOwner.group} - -"
    "d '${mediaDir}/library/music' 			0755 ${libraryOwner.user} ${libraryOwner.group} - -"
    "d '${mediaDir}/library/books' 			0755 ${libraryOwner.user} ${libraryOwner.group} - -"
    "d '${mediaDir}/library/audiobooks' 0755 ${libraryOwner.user} ${libraryOwner.group} - -"
  ];

  # Always prioritise Jellyfin IO
  systemd.services.jellyfin.serviceConfig.IOSchedulingPriority = 0;

  services.jellyfin = {
    inherit
      enable
      package
      openFirewall
      ;

    user = jellyfin.user;
    group = jellyfin.group;

    dataDir = stateDir;
    logDir = "${stateDir}/log";
    cacheDir = "${stateDir}/cache";
    configDir = "${stateDir}/config";

    hardwareAcceleration.enable = true;
    hardwareAcceleration.device = "/dev/dri/renderD128";
  };
}
