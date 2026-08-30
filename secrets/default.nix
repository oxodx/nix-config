{ inputs, pkgs, ... }:
let
  server = "age1fqkz7r00szqmnj72uuycsvxmd2p3hkqr05nncuhjfzmc2x0fnytsjw8028";
  laptop = "age1clkxk3teydq0f250s6xua4mhcx7jddp0rw65dvxeent7smurtqtq3e6yuv";
in
{
  imports = [ inputs.agenix.nixosModules.default ];

  environment.systemPackages = [
    inputs.agenix.packages."${pkgs.stdenv.hostPlatform.system}".default
  ];

  age.secrets = {
    "mullvad.conf" = { };
    "jellyfin-api-key" = { };
    "jellyfin-password-oxod" = { };
    "prowlarr-api-key" = { };
    "prowlarr-password" = { };
    "sonarr-api-key" = { };
    "sonarr-password" = { };
    "sonarr-anime-api-key" = { };
    "sonarr-anime-password" = { };
    "radarr-api-key" = { };
    "radarr-password" = { };
    "lidarr-api-key" = { };
    "lidarr-password" = { };
    "qbittorrent-password" = { };
    "seerr-api-key" = { };
  };
}
