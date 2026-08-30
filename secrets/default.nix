# This file is only used by the agenix CLI for rekeying.
# It defines the public keys used to encrypt secrets.
let
  server = "age1fqkz7r00szqmnj72uuycsvxmd2p3hkqr05nncuhjfzmc2x0fnytsjw8028";
  laptop = "age1clkxk3teydq0f250s6xua4mhcx7jddp0rw65dvxeent7smurtqtq3e6yuv";
  systems = [
    server
    laptop
  ];
in
{
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
