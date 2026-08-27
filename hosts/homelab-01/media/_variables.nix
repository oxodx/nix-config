rec {
  secrets = {
    vpn = "/etc/secrets/vpn/mullvad.conf";
    qbittorrent.password = "/etc/secrets/qbittorrent/password";
    seerr.apiKey = "/etc/secrets/seerr/api_key";
    jellyfin = {
      apiKey = "/etc/secrets/jellyfin/api_key";
      passwords = {
        oxod = "/etc/secrets/jellyfin/passwords/oxod";
      };
    };
    sonarr = {
      apiKey = "/etc/secrets/sonarr/api_key";
      password = "/etc/secrets/sonarr/password";
    };
    sonarr-anime = {
      apiKey = "/etc/secrets/sonarr-anime/api_key";
      password = "/etc/secrets/sonarr-anime/password";
    };
    radarr = {
      apiKey = "/etc/secrets/radarr/api_key";
      password = "/etc/secrets/radarr/password";
    };
    prowlarr = {
      apiKey = "/etc/secrets/prowlarr/api_key";
      password = "/etc/secrets/prowlarr/password";
    };
    lidarr = {
      apiKey = "/etc/secrets/lidarr/api_key";
      password = "/etc/secrets/lidarr/password";
    };
  };
}
