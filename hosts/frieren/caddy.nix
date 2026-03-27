{
  pkgs,
  config,
  ...
}:
let
  hostCommonConfig = ''
    encode zstd gzip
  '';
in
{
  services.resolved.enable = false;

  services.tailscale = {
    enable = true;
    permitCertUid = "caddy";
  };

  services.adguardhome = {
    enable = true;
    host = "127.0.0.1";
    port = 3003;
    settings = {
      dns = {
        upstream_dns = [
          "1.1.1.1"
          "8.8.8.8"
        ];
      };
      # The following notation uses map
      # to not have to manually create {enabled = true; url = "";} for every filter
      # This is, however, fully optional
      filters =
        map
          (url: {
            enabled = true;
            url = url;
          })
          [
            "https://adguardteam.github.io/HostlistsRegistry/assets/filter_9.txt" # The Big List of Hacked Malware Web Sites
            "https://adguardteam.github.io/HostlistsRegistry/assets/filter_11.txt" # malicious url blocklist
          ];
    };
  };

  services.caddy = {
    enable = true;
    # Reload Caddy instead of restarting it when configuration file changes.
    enableReload = true;
    user = "caddy"; # User account under which caddy runs.
    dataDir = "/data/apps/caddy";
    logDir = "/var/log/caddy";

    virtualHosts."http://frieren".extraConfig = ''
      # Glances
      handle /glances/* {
        reverse_proxy http://localhost:61208
      }
    '';
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  # Create Directories
  # https://www.freedesktop.org/software/systemd/man/latest/tmpfiles.d.html#Type
  systemd.tmpfiles.rules = [
    "d /data/apps/caddy 0755 caddy caddy"
    # "d /data/apps/caddy/fileserver/ 0755 caddy caddy"
  ];
}
