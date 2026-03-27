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
  services.tailscale = {
    enable = true;
    permitCertUid = "caddy";
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
