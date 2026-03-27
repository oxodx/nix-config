{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.services.forgejo;
  srv = cfg.settings.server;
in
{
  services.forgejo = {
    enable = true;
    user = "forgejo";
    group = "forgejo";
    stateDir = "/data/apps/forgejo";
    lfs.enable = true;
    dump = {
      enable = false;
      interval = "daily";
      file = "forgejo-dump";
      type = "tar.zst";
    };

    settings = {
      server = {
        DOMAIN = "git.oxod.nl";
        HTTP_PORT = 3008;
        SSH_PORT = lib.head config.services.openssh.ports;
        ROOT_URL = "http://${srv.DOMAIN}";
      };
      service.DISABLE_REGISTRATION = false;
      actions = {
        ENABLED = true;
        DEFAULT_ACTIONS_URL = "github";
      };
    };
  };
}
