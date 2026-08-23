{
  pkgs,
  lib,
  ...
}: let
  enable = true;
  package = pkgs.seerr;
  stateDir = "/var/lib/seerr";
  openFirewall = true;
  port = 5055;

  uids.seerr = 262;
  gids = {
    seerr = 250;
    media = 196;
  };

  libraryOwner = {
    user = "root";
    group = "media";
  };
  seerr = {
    user = "seerr";
    group = libraryOwner.group;
  };
in
  lib.mkIf enable {
    systemd.tmpfiles.rules = [
      "d '${stateDir}' 0700 ${seerr.user} root - -"
    ];

    systemd.services.seerr = {
      description = "Open-source media request and discovery manager for Jellyfin, Plex, and Emby";
      after = ["network.target"];
      wantedBy = ["multi-user.target"];
      environment = {
        PORT = toString port;
        CONFIG_DIRECTORY = stateDir;
      };

      serviceConfig = {
        Type = "exec";
        StateDirectory = "seerr";
        DynamicUser = false;
        User = seerr.user;
        Group = seerr.group;
        ExecStart = lib.getExe package;
        Restart = "on-failure";

        # Security
        ProtectHome = true;
        PrivateTmp = true;
        PrivateDevices = true;
        ProtectHostname = true;
        ProtectClock = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        ProtectControlGroups = true;
        NoNewPrivileges = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        RemoveIPC = true;
        PrivateMounts = true;
        ProtectSystem = "strict";
        ReadWritePaths = [stateDir];
      };
    };

    users = {
      groups.${seerr.group}.gid = gids.${seerr.group};
      users.${seerr.user} = {
        isSystemUser = true;
        group = seerr.group;
        uid = uids.${seerr.user};
      };
    };

    networking.firewall = lib.mkIf openFirewall {
      allowedTCPPorts = [port];
    };
  }
