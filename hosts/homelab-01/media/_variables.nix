rec {
  secrets = {
    vpn = "/root/secrets/mullvad.conf";
    qbittorrent.password = "/root/secrets/qbittorrent/password";
    seerr.apiKey = "/root/secrets/seerr/api_key";
    jellyfin = {
      apiKey = "/root/secrets/jellyfin/api_key";
      passwords = {
        oxod = "/root/secrets/jellyfin/passwords/oxod";
      };
    };
    sonarr = {
      apiKey = "/root/secrets/sonarr/api_key";
      password = "/root/secrets/sonarr/password";
    };
    sonarr-anime = {
      apiKey = "/root/secrets/sonarr-anime/api_key";
      password = "/root/secrets/sonarr-anime/password";
    };
    radarr = {
      apiKey = "/root/secrets/radarr/api_key";
      password = "/root/secrets/radarr/password";
    };
    prowlarr = {
      apiKey = "/root/secrets/prowlarr/api_key";
      password = "/root/secrets/prowlarr/password";
    };
  };
}
