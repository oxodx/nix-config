{
  config,
  lib,
  ...
}:
let
  cfg = config.nixflix.byparr;
in
{
  options.nixflix.byparr = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      example = true;
      description = "Whether or not to enable [Byparr](https://github.com/ThePhaseless/Byparr) for Prowlarr.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 8191;
      description = "Port for Byparr to listen on.";
    };
  };

  config = lib.mkIf (config.nixflix.enable && cfg.enable) {
    virtualisation.oci-containers.containers.byparr = {
      image = "ghcr.io/thephaseless/byparr:latest";
      autoStart = true;
      ports = [ "127.0.0.1:${toString cfg.port}:8191" ];
      volumes = [ "/var/lib/byparr:/config" ];
      environment = {
        LOG_LEVEL = "info";
        TZ = config.time.timeZone or "UTC";
      };
    };

    systemd.services.podman-byparr = {
      vpnConfinement = {
        enable = true;
        vpnNamespace = "wg";
      };
    };

    vpnNamespaces.wg.portMappings = [
      {
        from = cfg.port;
        to = cfg.port;
        protocol = "tcp";
      }
    ];

    systemd.tmpfiles.settings."10-byparr" = {
      "/var/lib/byparr".d = {
        mode = "0755";
        user = "root";
        group = "root";
      };
    };
  };
}
