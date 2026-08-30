{ inputs, ... }:
let
  server = "age1zrcqwqlzr47kdcjw9eg636jdk9tny48pxcxgyj954e668wp6jp8qjfayfg";
  laptop = "age1clkxk3teydq0f250s6xua4mhcx7jddp0rw65dvxeent7smurtqtq3e6yuv";
in
{
  imports = [ inputs.agenix.nixosModules.default ];

  age.identityPaths = [ "/root/.config/age/keys.txt" ];

  "secrets/mullvad.conf.age".publicKeys = [
    server
    laptop
  ];
  "secrets/jellyfin-api-key.age".publicKeys = [
    server
    laptop
  ];
  "secrets/jellyfin-password-oxod.age".publicKeys = [
    server
    laptop
  ];
  "secrets/prowlarr-api-key.age".publicKeys = [
    server
    laptop
  ];
  "secrets/prowlarr-password.age".publicKeys = [
    server
    laptop
  ];
  "secrets/sonarr-api-key.age".publicKeys = [
    server
    laptop
  ];
  "secrets/sonarr-password.age".publicKeys = [
    server
    laptop
  ];
  "secrets/sonarr-anime-api-key.age".publicKeys = [
    server
    laptop
  ];
  "secrets/sonarr-anime-password.age".publicKeys = [
    server
    laptop
  ];
  "secrets/radarr-api-key.age".publicKeys = [
    server
    laptop
  ];
  "secrets/radarr-password.age".publicKeys = [
    server
    laptop
  ];
  "secrets/lidarr-api-key.age".publicKeys = [
    server
    laptop
  ];
  "secrets/lidarr-password.age".publicKeys = [
    server
    laptop
  ];
  "secrets/qbittorrent-password.age".publicKeys = [
    server
    laptop
  ];
  "secrets/seerr-api-key.age".publicKeys = [
    server
    laptop
  ];
}
