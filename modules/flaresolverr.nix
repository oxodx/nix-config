{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixflix.flaresolverr;
in
{
  options.nixflix.flaresolverr = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      example = true;
      description = "Whether or not to enable [FlareSolverr](https://github.com/FlareSolverr/FlareSolverr) for Prowlarr.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 8191;
      description = "Port for FlareSolverr to listen on.";
    };

    logLevel = lib.mkOption {
      type = lib.types.enum [
        "info"
        "debug"
        "warn"
        "error"
      ];
      default = "info";
      description = "FlareSolverr log level.";
    };
  };

  config = lib.mkIf (config.nixflix.enable && cfg.enable) {
    virtualisation.oci-containers.containers.flaresolverr = {
      image = "ghcr.io/flaresolverr/flaresolverr:latest";
      ports = [ "${toString cfg.port}:8191" ];
      volumes = [ "/var/lib/flaresolverr:/data" ];
      environment = {
        LOG_LEVEL = cfg.logLevel;
      };
      autoStart = true;
      extraOptions = [
        "--pull=newer"
      ];
    };

    systemd.services.podman-flaresolverr = {
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      vpnConfinement = {
        enable = true;
        vpnNamespace = "wg";
      };
      serviceConfig = {
        Restart = "on-failure";
        RestartSec = 5;
      };
    };

    vpnNamespaces.wg.portMappings = [
      {
        from = cfg.port;
        to = cfg.port;
        protocol = "tcp";
      }
    ];
  };
}
