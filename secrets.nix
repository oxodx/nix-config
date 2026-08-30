# This file is only used by the agenix CLI for rekeying.
# It defines the public keys used to encrypt secrets.
let
  homelab-01 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAS1HiLGivx51vMROMeQ0Kua/+n8vaqPNx3LPCIffGjC root@homelab-01";
  laptop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKzn1ueT+hOMYIjgQg1ln9aPTm9GLMwKc6OENw2qhsqG root@laptop";
  disaster = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINkrWyQbDI7/PAqRn+y3uK2K+ZMNgzkCxdirXUpU3LJm oxod@disaster";
  systems = [homelab-01 laptop disaster];
in {
  "./mullvad.conf.age".publicKeys = systems;
  "./jellyfin-api-key.age".publicKeys = systems;
  "./jellyfin-password-oxod.age".publicKeys = systems;
  "./prowlarr-api-key.age".publicKeys = systems;
  "./prowlarr-password.age".publicKeys = systems;
  "./sonarr-api-key.age".publicKeys = systems;
  "./sonarr-password.age".publicKeys = systems;
  "./sonarr-anime-api-key.age".publicKeys = systems;
  "./sonarr-anime-password.age".publicKeys = systems;
  "./radarr-api-key.age".publicKeys = systems;
  "./radarr-password.age".publicKeys = systems;
  "./lidarr-api-key.age".publicKeys = systems;
  "./lidarr-password.age".publicKeys = systems;
  "./qbittorrent-password.age".publicKeys = systems;
  "./seerr-api-key.age".publicKeys = systems;
}
