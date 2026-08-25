{
  pkgs,
  lib,
  ...
}: let
  vars = import ./_variables.nix;
  vUser = vars.services.qbittorrent.user;
  vGroup = vars.services.qbittorrent.group;

  enable = true;
  package = pkgs.qbittorrent-nox;
  stateDir = "${vars.dirs.state}/qbittorrent";
  downloadDir = "${vars.dirs.media}/downloads";
  openFirewall = true;
  webuiPort = 8080;
  peerPort = 6881;

  qbittorrentConfig = {
    BitTorrent = {
      "Session\\DefaultSavePath" = downloadDir;
      "Session\\TempPath" = "${downloadDir}/.incomplete";
      "Session\\TempPathEnabled" = true;
      "Session\\Port" = peerPort;
      "Session\\DHTEnabled" = true;
      "Session\\PeXEnabled" = true;
      "Session\\LSDEnabled" = true;
      "Session\\Encryption" = 1;
      "Session\\GlobalMaxRatio" = -1;
      "Session\\MaxActiveDownloads" = 5;
      "Session\\MaxActiveTorrents" = 10;
      "Session\\MaxActiveUploads" = 10;
    };
    Preferences = {
      "WebUI\\Port" = webuiPort;
      "WebUI\\Address" =
        if vars.vpn.enable
        then "192.168.15.1"
        else "*";
      "WebUI\\LocalHostAuth" = false;
      "WebUI\\HostHeaderValidation" = false;
      "Downloads\\SavePath" = downloadDir;
      "Downloads\\TempPath" = "${downloadDir}/.incomplete";
      "Downloads\\TempPathEnabled" = true;
      "Downloads\\PreAllocation" = true;
    };
  };
in {
  systemd.tmpfiles.rules = [
    "d '${stateDir}' 0700 ${vUser} root - -"
    "d '${stateDir}/config' 0700 ${vUser} root - -"
    "d '${downloadDir}' 0775 ${vUser} ${vars.libraryOwner.group} - -"
    "d '${downloadDir}/.incomplete' 0775 ${vUser} ${vars.libraryOwner.group} - -"
  ];

  services.qbittorrent = {
    inherit
      enable
      package
      ;

    openFirewall = openFirewall && !vars.vpn.enable;

    user = vUser;
    group = vGroup;

    profileDir = stateDir;
    webuiPort = webuiPort;
    torrentingPort = peerPort;
    serverConfig = qbittorrentConfig;
  };

  systemd.services.qbittorrent.serviceConfig.IOSchedulingPriority = 7;

  systemd.services.qbittorrent.vpnConfinement = lib.mkIf vars.vpn.enable {
    enable = true;
    vpnNamespace = "wg";
  };

  vpnNamespaces.wg = lib.mkIf vars.vpn.enable {
    portMappings = [
      {
        from = webuiPort;
        to = webuiPort;
      }
    ];
    openVPNPorts = [
      {
        port = peerPort;
        protocol = "both";
      }
    ];
  };

  users = {
    groups.${vGroup}.gid = vars.gids.${vGroup};
    users.${vUser} = {
      isSystemUser = true;
      group = vGroup;
      uid = vars.uids.${vUser};
      extraGroups = [vars.libraryOwner.group];
    };
  };

  networking.firewall = lib.mkIf (openFirewall && !vars.vpn.enable) {
    allowedTCPPorts = [
      webuiPort
      peerPort
    ];
    allowedUDPPorts = [peerPort];
  };
}
