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

  environment.systemPackages = [inputs.agenix.packages."${pkgs.stdenv.hostPlatform.system}".default
  ];

  age.secrets = {
    "mullvad.conf".publicKeys = [
      server
      laptop
    ];
    "jellyfin-api-key".publicKeys = [
      server
      laptop
    ];
    "jellyfin-password-oxod".publicKeys = [
      server
      laptop
    ];
    "prowlarr-api-key".publicKeys = [
      server
      laptop
    ];
    "prowlarr-password".publicKeys = [
      server
      laptop
    ];
    "sonarr-api-key".publicKeys = [
      server
      laptop
    ];
    "sonarr-password".publicKeys = [
      server
      laptop
    ];
    "sonarr-anime-api-key".publicKeys = [
      server
      laptop
    ];
    "sonarr-anime-password".publicKeys = [
      server
      laptop
    ];
    "radarr-api-key".publicKeys = [
      server
      laptop
    ];
    "radarr-password".publicKeys = [
      server
      laptop
    ];
    "lidarr-api-key".publicKeys = [
      server
      laptop
    ];
    "lidarr-password".publicKeys = [
      server
      laptop
    ];
    "qbittorrent-password".publicKeys = [
      server
      laptop
    ];
    "seerr-api-key".publicKeys = [
      server
      laptop
    ];
  };
}
