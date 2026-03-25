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
  services.caddy = {
    enable = true;
    # Reload Caddy instead of restarting it when configuration file changes.
    enableReload = true;
    user = "caddy"; # User account under which caddy runs.
    dataDir = "/data/apps/caddy";
    logDir = "/var/log/caddy";

    # Dashboard
    # virtualHosts."http://home.oxod.nl".extraConfig = ''
    #   ${hostCommonConfig}
    #   reverse_proxy http://localhost:54401
    # '';

    # https://caddyserver.com/docs/caddyfile/directives/file_server
    # virtualHosts."http://file.oxod.nl".extraConfig = ''
    #   root * /data/apps/caddy/fileserver/
    #   ${hostCommonConfig}
    #   file_server browse {
    #     hide .git
    #     precompressed zstd br gzip
    #   }
    # '';
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  # Create Directories
  # https://www.freedesktop.org/software/systemd/man/latest/tmpfiles.d.html#Type
  systemd.tmpfiles.rules = [
    "d /data/apps/caddy 0755 caddy caddy"
    "d /data/apps/caddy/fileserver/ 0755 caddy caddy"
  ];
}
