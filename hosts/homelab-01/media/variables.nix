rec {
  dirs = {
    media = "/mnt/media";
    state = "/var/lib";
  };

  libraryOwner.user = "root";
  libraryOwner.group = "media";

  uids = {
    media = 999;
    jellyfin = 146;
    seerr = 262;
  };
  gids = {
    media = 196;
    seerr = 250;
  };

  services = {
    seerr = {
      user = "seerr";
      group = libraryOwner.group;
    };
    jellyfin = {
      user = "jellyfin";
      group = libraryOwner.group;
    };
  };
}
