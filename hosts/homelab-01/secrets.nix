{
  config,
  lib,
  ...
}:
{
  sops.defaultSopsFile = ../../../secrets/homelab-01.yaml;
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

  sops.secrets = {
    "vpn/mullvad.conf" = {
      mode = "0400";
      owner = "root";
    };

    "jellyfin/api_key" = {
      mode = "0400";
      owner = "root";
    };
    "jellyfin/passwords/oxod" = {
      mode = "0400";
      owner = "root";
    };

    "sonarr/api_key" = {
      mode = "0400";
      owner = "root";
    };
    "sonarr/password" = {
      mode = "0400";
      owner = "root";
    };

    "sonarr-anime/api_key" = {
      mode = "0400";
      owner = "root";
    };
    "sonarr-anime/password" = {
      mode = "0400";
      owner = "root";
    };

    "radarr/api_key" = {
      mode = "0400";
      owner = "root";
    };
    "radarr/password" = {
      mode = "0400";
      owner = "root";
    };

    "prowlarr/api_key" = {
      mode = "0400";
      owner = "root";
    };
    "prowlarr/password" = {
      mode = "0400";
      owner = "root";
    };

    "lidarr/api_key" = {
      mode = "0400";
      owner = "root";
    };
    "lidarr/password" = {
      mode = "0400";
      owner = "root";
    };

    "qbittorrent/password" = {
      mode = "0400";
      owner = "root";
    };

    "seerr/api_key" = {
      mode = "0400";
      owner = "root";
    };
  };
}
