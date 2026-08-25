{
  lib,
  pkgs,
  mylib,
  config,
  ...
}: {
  nixflix.torrentClients.qbittorrent = {
    enable = true;
    vpn.enable = true;
    openFirewall = true;

    serverConfig = {
      LegalNotice.Accepted = true;
      BitTorrent = {
        Session = {
          AddTorrentStopped = false;
          Port = 45500;
          QueueingSystemEnabled = true;
          SSL.Port = 32380;
        };
        ShareLimits = {
          RatioLimit = 0;
          RatioAction = 0;
        };
      };
      Preferences.WebUI = {
        Username = "oxod";
        LocalHostAuth = false;
        HostHeaderValidation = false;
        AuthSubnetWhitelistEnabled = true;
        AuthSubnetWhitelist = "192.168.1.0/24, 192.168.15.0/24";
        CSRFProtection = false;
      };
      General.Locale = "en";
    };
  };

  networking.firewall.allowedTCPPorts = [8282];
}
