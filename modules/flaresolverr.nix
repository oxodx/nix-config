{
  config,
  lib,
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
  };

  config = lib.mkIf (config.nixflix.enable && cfg.enable) {
    services.flaresolverr = {
      enable = true;
      inherit (cfg) port;
      openFirewall = true;
    };

    systemd.services.flaresolverr = {
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
  };
}
