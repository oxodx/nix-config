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
        Password_PBKDF2 = "@ByteArray(E8Rb7a+iNYZVZ1syplyf4w==:6xklmx1436K9mMDS01lItuaacQYBXnDiP0rEAOtEJw0=)";
      };
      General.Locale = "en";
    };
  };

  networking.firewall.allowedTCPPorts = [ 8282 ];
}
