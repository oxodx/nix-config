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

    # Additional lines of configuration appended to the global config section of the Caddyfile.
    # Refer to https://caddyserver.com/docs/caddyfile/options#global-options for details on supported values.
    globalConfig = ''
      http_port    80
      https_port   443
      auto_https   disable_certs
    '';

    virtualHosts."localhost".extraConfig = ''
      ${hostCommonConfig}
      respond "Hello, world!"
    '';
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  # Create Directories
  # https://www.freedesktop.org/software/systemd/man/latest/tmpfiles.d.html#Type
  systemd.tmpfiles.rules = [
    "d /data/apps/caddy/fileserver/ 0755 caddy caddy"
    # directory for virtual machine's images
    "d /data/apps/caddy/fileserver/vms 0755 caddy caddy"
  ];
}
