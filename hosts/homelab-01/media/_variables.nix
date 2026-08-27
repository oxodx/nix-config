rec {
  secrets = {
    vpn = "/run/secrets/vpn/mullvad.conf";
    qbittorrent.password = "/run/secrets/qbittorrent/password";
    seerr.apiKey = "/run/secrets/seerr/api_key";
    jellyfin = {
      apiKey = "/run/secrets/jellyfin/api_key";
      passwords = {
        oxod = "/run/secrets/jellyfin/passwords/oxod";
      };
    };
    sonarr = {
      apiKey = "/run/secrets/sonarr/api_key";
      password = "/run/secrets/sonarr/password";
    };
    sonarr-anime = {
      apiKey = "/run/secrets/sonarr-anime/api_key";
      password = "/run/secrets/sonarr-anime/password";
    };
    radarr = {
      apiKey = "/run/secrets/radarr/api_key";
      password = "/run/secrets/radarr/password";
    };
    prowlarr = {
      apiKey = "/run/secrets/prowlarr/api_key";
      password = "/run/secrets/prowlarr/password";
    };
    lidarr = {
      apiKey = "/run/secrets/lidarr/api_key";
      password = "/run/secrets/lidarr/password";
    };
  };
}
