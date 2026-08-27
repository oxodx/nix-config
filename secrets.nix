let
  server = "age1fqkz7r00szqmnj72uuycsvxmd2p3hkqr05nncuhjfzmc2x0fnytsjw8028";
  laptop = "age13dq6y4q8vdr4sp7nqp5gmh2luvk05cpp02s6x88nw3cl8znc7slq6a2dq8";
in {
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
