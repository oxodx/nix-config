{
  lib,
  pkgs,
  mylib,
  config,
  ...
}:
let
  vars = import ./_variables.nix;
in
{
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
        Password_PBKDF2 = "@ByteArray(RThSYjdhK2lOWVpWWjFzeXBseWY0dz09OmI4cE5SOGxPaWZIUmtsR3c0S1h0aVQrSGtuQlZGUXBucG9HZHBKakJYekpYSUgwMkZwU2c4dnI2Nmx3TU5aRWRmVlJVdlMzZE5zQU9ZMGRkZU95RUpRPT0=)";
      };
      General.Locale = "en";
    };
  };

  networking.firewall.allowedTCPPorts = [ 8282 ];
}
