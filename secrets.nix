# This file is only used by the agenix CLI for rekeying.
# It defines the public keys used to encrypt secrets.
let
  homelab-01 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAS1HiLGivx51vMROMeQ0Kua/+n8vaqPNx3LPCIffGjC root@homelab-01";
  laptop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKzn1ueT+hOMYIjgQg1ln9aPTm9GLMwKc6OENw2qhsqG root@laptop";
  disaster = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINkrWyQbDI7/PAqRn+y3uK2K+ZMNgzkCxdirXUpU3LJm oxod@disaster";
  systems = [
    homelab-01
    laptop
    disaster
  ];
in
{
  "secrets/mullvad.conf.age".publicKeys = systems;
  "secrets/jellyfin-api-key.age".publicKeys = systems;
  "secrets/jellyfin-password-oxod.age".publicKeys = systems;
  "secrets/prowlarr-api-key.age".publicKeys = systems;
  "secrets/prowlarr-password.age".publicKeys = systems;
  "secrets/sonarr-api-key.age".publicKeys = systems;
  "secrets/sonarr-password.age".publicKeys = systems;
  "secrets/sonarr-anime-api-key.age".publicKeys = systems;
  "secrets/sonarr-anime-password.age".publicKeys = systems;
  "secrets/radarr-api-key.age".publicKeys = systems;
  "secrets/radarr-password.age".publicKeys = systems;
  "secrets/lidarr-api-key.age".publicKeys = systems;
  "secrets/lidarr-password.age".publicKeys = systems;
  "secrets/qbittorrent-password.age".publicKeys = systems;
  "secrets/seerr-api-key.age".publicKeys = systems;
}
