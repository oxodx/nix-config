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
    };

    systemd.services.podman-flaresolverr = {
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
    };

    systemd.services.flaresolverr.serviceConfig.ExecStartPost =
      pkgs.writeShellScript "wait-for-flaresolverr" ''
        for i in $(seq 1 30); do
          if ${pkgs.curl}/bin/curl -sf http://127.0.0.1:${toString cfg.port}/ >/dev/null 2>&1; then
            exit 0
          fi
          sleep 1
        done
        echo "FlareSolverr did not become ready within 30s"
        exit 1
      '';
  };
}
