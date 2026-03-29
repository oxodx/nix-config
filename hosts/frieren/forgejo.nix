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
        ROOT_URL = "https://${srv.DOMAIN}";
      };
      service.DISABLE_REGISTRATION = true;
      actions = {
        ENABLED = true;
        DEFAULT_ACTIONS_URL = "github";
      };
    };
  };

  services.gitea-actions-runner = {
    package = pkgs.forgejo-runner;
    instances.default = {
      enable = true;
      name = "frieren";
      url = "https://${srv.DOMAIN}";
      tokenFile = config.age.secrets.forgejo-runner-token.path;
      labels = [
        "ubuntu-latest:docker://node:20-bookworm"
        "ubuntu-22.04:docker://node:20-bookworm"
        "ubuntu-24.04:docker://node:22-noble"
      ];
      settings = {
        container = {
          network = "host";
        };
      };
    };
  };
}
