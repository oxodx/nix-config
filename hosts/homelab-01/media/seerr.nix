{
  pkgs,
  lib,
  ...
}: let
  vars = import ./_variables.nix;
  vUser = vars.services.seerr.user;
  vGroup = vars.services.seerr.group;

  enable = true;
  package = pkgs.seerr;
  stateDir = "${vars.dirs.state}/seerr";
  openFirewall = true;
  port = 5055;
in
  lib.mkIf enable {
    systemd.tmpfiles.rules = [
      "d '${stateDir}' 0700 ${vUser} root - -"
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
        User = vUser;
        Group = vGroup;
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
      groups.${vGroup}.gid = vars.gids.${vGroup};
      users.${vUser} = {
        isSystemUser = true;
        group = vGroup;
        uid = vars.uids.${vUser};
      };
    };

    networking.firewall = lib.mkIf openFirewall {
      allowedTCPPorts = [port];
    };
  }
