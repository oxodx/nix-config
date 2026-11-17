{
  config,
  lib,
  pkgs,
  secrets,
  ...
}: let
  forgejo = lib.getExe config.services.forgejo.package;
  forgejoConfig = "${config.services.forgejo.customDir}/conf/app.ini";
in {
  age.secrets.cloudflare-tunnel-token = {
    file = ../../../secrets/cloudflare-tunnel-token.age;
    path = secrets.cloudflareTunnelToken;
    owner = "root";
    group = "root";
    mode = "0400";
  };

  services.forgejo = {
    enable = true;
    database.type = "postgres";
    lfs.enable = true;

    settings = {
      DEFAULT.APP_NAME = "oxod's forge";

      server = {
        DOMAIN = "git.oxod.nl";
        ROOT_URL = "https://git.oxod.nl/";
        HTTP_ADDR = "127.0.0.1";
        HTTP_PORT = 3001;
        PROTOCOL = "http";
        DISABLE_SSH = true;
        LANDING_PAGE = "explore";
      };

      service = {
        DISABLE_REGISTRATION = true;
        REQUIRE_SIGNIN_VIEW = false;
        ENABLE_NOTIFY_MAIL = false;
      };

      actions.ENABLED = true;
      session.COOKIE_SECURE = true;
      security = {
        REVERSE_PROXY_LIMIT = 1;
        REVERSE_PROXY_TRUSTED_PROXIES = "127.0.0.1/8,::1/128";
      };
      repository = {
        DEFAULT_PRIVATE = "private";
        ENABLE_PUSH_CREATE_USER = true;
      };
      "cron.archive_cleanup".ENABLED = true;
      log.LEVEL = "Info";
    };
  };

  # Generate the instance-scoped registration credential at runtime. It never
  # enters the Nix store or Git, and the runner keeps its registered identity in
  # its private StateDirectory after the first successful registration.
  systemd.services.forgejo-runner-token = {
    description = "Generate the local Forgejo Actions runner token";
    after = ["forgejo.service"];
    requires = ["forgejo.service"];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      User = config.services.forgejo.user;
      Group = config.services.forgejo.group;
      RuntimeDirectory = "forgejo-runner-token";
      RuntimeDirectoryMode = "0700";
      UMask = "0077";
    };
    script = ''
      token="$(${forgejo} --config ${lib.escapeShellArg forgejoConfig} actions generate-runner-token)"
      printf 'TOKEN=%s\n' "$token" > /run/forgejo-runner-token/token.env
    '';
  };

  systemd.services.gitea-runner-gawain = {
    after = ["forgejo-runner-token.service"];
    requires = ["forgejo-runner-token.service"];
  };

  services.gitea-actions-runner.instances.gawain = {
    enable = true;
    name = "gawain";
    # Job containers cannot use the host's loopback URL. Register with the
    # public tunnel URL so actions/checkout receives a reachable server URL.
    url = "https://git.oxod.nl";
    tokenFile = "/run/forgejo-runner-token/token.env";
    labels = [
      "ubuntu-latest:docker://node:20-bookworm"
      "debian-latest:docker://node:20-bookworm"
    ];
    settings.runner = {
      capacity = 1;
      timeout = "1h";
    };
    # Auto-detection advertises the cache on Gawain's LAN address, which is not
    # reachable from isolated Docker job networks through the host firewall.
    # Disable the remote Actions cache rather than weakening container isolation.
    settings.cache.enabled = false;
  };

  # CI jobs are untrusted code. Keep Actions restricted to repositories whose
  # workflows you trust; Docker-backed jobs effectively control this node.
  virtualisation.docker = {
    enable = true;
    # Configure DNS at the daemon level. Passing --dns to every runner-created
    # container conflicts with the network mode used by container actions.
    daemon.settings.dns = ["1.1.1.1" "9.9.9.9"];
  };

  # One remotely managed tunnel carries public homelab traffic to Caddy's
  # loopback-only ingress. Caddy explicitly allow-lists and routes hostnames.
  # The token is passed as a systemd credential and never enters the Nix store,
  # the unit's environment, or its command line.
  systemd.services.cloudflared-homelab = {
    description = "Cloudflare Tunnel for the homelab";
    wantedBy = ["multi-user.target"];
    after = ["network-online.target" "caddy.service"];
    wants = ["network-online.target"];
    serviceConfig = {
      Type = "simple";
      DynamicUser = true;
      LoadCredential = "tunnel-token:${secrets.cloudflareTunnelToken}";
      ExecStart = "${lib.getExe pkgs.cloudflared} tunnel --no-autoupdate run --token-file %d/tunnel-token --url http://127.0.0.1:8082";
      Restart = "on-failure";
      RestartSec = "5s";
    };
  };
}
