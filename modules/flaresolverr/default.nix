{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.services.flaresolverr;
in
{
  options.services.flaresolverr = {
    enable = mkEnableOption "FlareSolverr proxy for bypassing Cloudflare";

    port = mkOption {
      type = types.port;
      default = 8191;
      description = "Port FlareSolverr listens on.";
    };

    dataDir = mkOption {
      type = types.path;
      default = "/var/lib/flaresolverr";
      description = "Directory for FlareSolverr data.";
    };

    logLevel = mkOption {
      type = types.enum [
        "info"
        "debug"
        "warn"
        "error"
      ];
      default = "info";
      description = "FlareSolverr log level.";
    };
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers.containers.flaresolverr = {
      image = "ghcr.io/flaresolverr/flaresolverr:latest";
      ports = [ "${toString cfg.port}:8191" ];
      volumes = [ "${cfg.dataDir}:/data" ];
      environment = {
        LOG_LEVEL = cfg.logLevel;
      };
      autoStart = true;
    };

    systemd.services.podman-flaresolverr = {
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
    };
  };
}
