let
  storage = {
    media = "/mnt/media";
  };
in {
  services = {
    jellyfin = {
      enable = true;
      openFirewall = true;
    };

    seerr = {
      enable = true;
      openFirewall = true;
    };
  };

  users.users.media = {
    isSystemUser = true;
    group = "media";
    createHome = false;
  };
  users.groups.media = {};
}
