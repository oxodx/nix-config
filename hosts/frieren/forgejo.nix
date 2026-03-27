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
        DOMAIN = "192.168.1.184";
        HTTP_PORT = 3008;
        SSH_PORT = lib.head config.services.openssh.ports;
        ROOT_URL = "http://${srv.DOMAIN}:3008";
      };
      service.DISABLE_REGISTRATION = true;
      actions = {
        ENABLED = true;
        DEFAULT_ACTIONS_URL = "github";
      };
    };
  };

  services.woodpecker = {
    enable = true;
    user = "woodpecker";
    group = "woodpecker";
    stateDir = "/data/apps/woodpecker";

    settings = {
      server = {
        DOMAIN = "192.168.1.184";
        HTTP_PORT = 8080;
        ROOT_URL = "http://${config.services.woodpecker.settings.server.DOMAIN}:${config.services.woodpecker.settings.server.HTTP_PORT}";
        SECRET = lib.mkSecret "woodpecker-secret";
        DB_DRIVER = "sqlite3";
        DB_DATASOURCE = "${config.services.woodpecker.stateDir}/woodpecker.sqlite";
      };

      agent = {
        ENABLED = false;
        SERVER_URL = "http://127.0.0.1:8080";
        LABELS = "";
        REGISTRATION_TOKEN = "";
      };
    };

    dump = {
      enable = false;
      interval = "daily";
      file = "woodpecker-dump";
      type = "tar.zst";
    };
  };
}
