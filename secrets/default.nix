{
  inputs,
  pkgs,
  ...
}:
let
  server = "age1fqkz7r00szqmnj72uuycsvxmd2p3hkqr05nncuhjfzmc2x0fnytsjw8028";
  laptop = "age1clkxk3teydq0f250s6xua4mhcx7jddp0rw65dvxeent7smurtqtq3e6yuv";
in
{
  imports = [ inputs.agenix.nixosModules.default ];

  environment.systemPackages = [ inputs.agenix."${pkgs.stdenv.hostPlatform.system}".default ];

  age.identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

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
