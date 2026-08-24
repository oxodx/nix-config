rec {
  dirs = {
    media = "/mnt/media";
    state = "/var/lib";
  };

  libraryOwner.user = "root";
  libraryOwner.group = "media";

  uids = {
    jellyfin = 146;
    seerr = 262;
  };
  gids = {
    seerr = 250;
    media = 196;
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
