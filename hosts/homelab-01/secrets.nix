{
  self,
  config,
  lib,
  ...
}: {
  age.identityPaths = ["/root/.config/age/keys.txt"];

  age.secrets = {
    "mullvad.conf" = {
      file = self + "/secrets/mullvad.conf.age";
      path = "/etc/secrets/vpn/mullvad.conf";
    };
    "jellyfin-api-key" = {
      file = self + "/secrets/jellyfin-api-key.age";
      path = "/etc/secrets/jellyfin/api_key";
    };
    "jellyfin-password-oxod" = {
      file = self + "/secrets/jellyfin-password-oxod.age";
      path = "/etc/secrets/jellyfin/passwords/oxod";
    };
    "prowlarr-api-key" = {
      file = self + "/secrets/prowlarr-api-key.age";
      path = "/etc/secrets/prowlarr/api_key";
    };
    "prowlarr-password" = {
      file = self + "/secrets/prowlarr-password.age";
      path = "/etc/secrets/prowlarr/password";
    };
    "sonarr-api-key" = {
      file = self + "/secrets/sonarr-api-key.age";
      path = "/etc/secrets/sonarr/api_key";
    };
    "sonarr-password" = {
      file = self + "/secrets/sonarr-password.age";
      path = "/etc/secrets/sonarr/password";
    };
    "sonarr-anime-api-key" = {
      file = self + "/secrets/sonarr-anime-api-key.age";
      path = "/etc/secrets/sonarr-anime/api_key";
    };
    "sonarr-anime-password" = {
      file = self + "/secrets/sonarr-anime-password.age";
      path = "/etc/secrets/sonarr-anime/password";
    };
    "radarr-api-key" = {
      file = self + "/secrets/radarr-api-key.age";
      path = "/etc/secrets/radarr/api_key";
    };
    "radarr-password" = {
      file = self + "/secrets/radarr-password.age";
      path = "/etc/secrets/radarr/password";
    };
    "lidarr-api-key" = {
      file = self + "/secrets/lidarr-api-key.age";
      path = "/etc/secrets/lidarr/api_key";
    };
    "lidarr-password" = {
      file = self + "/secrets/lidarr-password.age";
      path = "/etc/secrets/lidarr/password";
    };
    "qbittorrent-password" = {
      file = self + "/secrets/qbittorrent-password.age";
      path = "/etc/secrets/qbittorrent/password";
    };
    "seerr-api-key" = {
      file = self + "/secrets/seerr-api-key.age";
      path = "/etc/secrets/seerr/api_key";
    };
  };
}
