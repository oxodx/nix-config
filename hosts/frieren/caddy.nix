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

  services.uptime-kuma = {
    enable = true;
    settings.PORT = "53350";
  };

  services.caddy = {
    enable = true;
    # Reload Caddy instead of restarting it when configuration file changes.
    enableReload = true;
    user = "caddy"; # User account under which caddy runs.
    dataDir = "/data/apps/caddy";
    logDir = "/var/log/caddy";

    virtualHosts = {
      "home.oxod.nl:80".extraConfig = ''
        ${hostCommonConfig}
        reverse_proxy http://localhost:8082
      '';

      "git.oxod.nl:80".extraConfig = ''
        ${hostCommonConfig}
        reverse_proxy http://localhost:3008
      '';

      "glances.oxod.nl:80".extraConfig = ''
        ${hostCommonConfig}
        reverse_proxy http://localhost:61208
      '';

      "uptime.oxod.nl:80".extraConfig = ''
        ${hostCommonConfig}
        reverse_proxy http://localhost:53350
      '';

      "jellyfin.oxod.nl:80".extraConfig = ''
        ${hostCommonConfig}
        reverse_proxy http://localhost:8096
      '';

      "adguard.oxod.nl:80".extraConfig = ''
        ${hostCommonConfig}
        reverse_proxy http://localhost:3003
      '';
    };
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
