{
  lib,
  pkgs,
  mylib,
  config,
  ...
}: let
  vars = import ./_variables.nix;
in {
  nixflix.torrentClients.qbittorrent = {
    enable = true;
    vpn.enable = true;
    openFirewall = true;
    password._secret = vars.secrets.qbittorrent.password;

    serverConfig = {
      LegalNotice.Accepted = true;
      BitTorrent = {
        Session = {
          AddTorrentStopped = false;
          Port = 45500;
          QueueingSystemEnabled = true;
          SSL.Port = 32380;
        };
      };
      Preferences.WebUI = {
        Username = "oxod";
        Password_PBKDF2 = "@ByteArray(bJq7nF2xL9mP4sK8:bV6xN2mP8sK1zL4wQ9jF3tH5rY7dE1aC6bU8mN2pX4vS5fG9hJ3kL7zQ1wX3yZ5==)";
      };
      General.Locale = "en";
    };
  };

  networking.firewall.allowedTCPPorts = [8282];
}
