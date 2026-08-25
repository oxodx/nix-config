{
  lib,
  config,
  ...
}: {
  nixflix = {
    enable = true;

    mediaDir = "/mnt/media";
    downloadsDir = "/mnt/media/downloads";
    stateDir = "/var/lib";

    mediaUsers = ["oxod"];

    vpn = {
      enable = true;
      wgConfFile = "/root/secrets/mullvad.conf";
      accessibleFrom = [
        "10.0.0.0/8"
        "172.16.0.0/12"
        "192.168.0.0/16"
      ];
    };

    nginx = {
      enable = true;
      domain = "homelab.local";
      addHostsEntries = true;
    };

    jellyfin = {
      enable = true;
      openFirewall = true;
    };

    sonarr = {
      enable = true;
      openFirewall = true;
    };

    radarr = {
      enable = true;
      openFirewall = true;
    };

    prowlarr = {
      enable = true;
      openFirewall = true;
    };

    seerr = {
      enable = true;
      openFirewall = true;
    };

    torrentClients.qbittorrent = {
      enable = true;
      vpn.enable = true;
      openFirewall = true;
    };
  };
}
