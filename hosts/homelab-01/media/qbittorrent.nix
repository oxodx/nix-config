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
        Password_PBKDF2 = "@ByteArray(RThSYjdhK2lOWVpWWjFzeXBseWY0dz09Om42dmlnSU42SDJRZkMvTUJ1K0pzUFRmTmJzbS9adDU3ajNXU2NiSlFxZ0hzbFRqQ1BtclJqM2Q1bXREQ3N1MktxRzViYkJBT3dpUHlkV2NWbis3SDVnPT0=)";
      };
      General.Locale = "en";
    };
  };

  networking.firewall.allowedTCPPorts = [8282];
}
