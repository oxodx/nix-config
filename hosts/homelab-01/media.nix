{
  lib,
  config,
  ...
}:
{
  nixflix = {
    enable = true;
    stateDir = "/var/lib";
    mediaDir = "/mnt/media";
    downloadsDir = "/mnt/media/downloads";
    mediaUsers = [ "oxod" ];

    theme = {
      enable = true;
      name = "overseerr";
    };

    nginx = {
      enable = true;
      addHostsEntries = true;
    };

    postgres.enable = true;

    sonarr = {
      enable = true;
      openFirewall = true;
      config = {
        apiKey._secret = "/root/secrets/sonarr/api_key";
        hostConfig.password._secret = "/root/secrets/sonarr/password";
      };
    };

    radarr = {
      enable = true;
      openFirewall = true;
      config = {
        apiKey._secret = "/root/secrets/radarr/api_key";
        hostConfig.password._secret = "/root/secrets/radarr/password";
      };
    };

    recyclarr = {
      enable = true;
      cleanupUnmanagedProfiles.enable = true;
    };

    prowlarr = {
      enable = true;
      openFirewall = true;
      config = {
        apiKey._secret = "/root/secrets/prowlarr/api_key";
        hostConfig.password._secret = "/root/secrets/prowlarr/password";
      };
    };

    seerr = {
      enable = true;
      apiKey._secret = "/root/secrets/seerr/api_key";
    };

    jellyfin = {
      enable = true;
      openFirewall = true;
      apiKey._secret = "/root/secrets/jellyfin/api_key";
      users = {
        oxod = {
          mutable = false;
          policy.isAdministrator = true;
          password._secret = "/root/secrets/jellyfin/passwords/oxod";
        };
      };
    };

    torrentClients.qbittorrent = {
      enable = true;
      vpn.enable = true;
      openFirewall = true;
    };

    vpn = {
      enable = true;
      wgConfFile = "/root/secrets/mullvad.conf";
      accessibleFrom = [ "192.168.1.0/24" ];
    };
  };
}
