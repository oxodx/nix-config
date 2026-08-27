{
  config,
  lib,
  ...
}:
{
  sops.defaultSopsFile = ../../secrets/homelab-01.yaml;
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

  sops.secrets = {
    "vpn/mullvad.conf" = { };
    "jellyfin/api_key" = { };
    "jellyfin/passwords/oxod" = { };
    "sonarr/api_key" = { };
    "sonarr/password" = { };
    "sonarr-anime/api_key" = { };
    "sonarr-anime/password" = { };
    "radarr/api_key" = { };
    "radarr/password" = { };
    "prowlarr/api_key" = { };
    "prowlarr/password" = { };
    "lidarr/api_key" = { };
    "lidarr/password" = { };
    "qbittorrent/password" = { };
    "seerr/api_key" = { };
  };
}
