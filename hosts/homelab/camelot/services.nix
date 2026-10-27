{
  inputs,
  lib,
  pkgs,
  ...
}: let
  unstablePkgs = import inputs.nixpkgs-unstable {
    inherit (pkgs.stdenv.hostPlatform) system;
    config.allowUnfree = true;
  };
in {
  imports = [./docker.nix];

  services = {
    sonarr = {
      enable = true;
      package = pkgs.sonarr;
      user = "sonarr";
      group = "media";
      settings.server.port = 8989;
      openFirewall = true;
      dataDir = "/data/.state/media/sonarr";
    };

    radarr = {
      enable = true;
      openFirewall = true;
      dataDir = "/data/.state/media/radarr";
      group = "media";
    };

    jellyfin = {
      enable = true;
      openFirewall = true;
      package = unstablePkgs.jellyfin;
      forceEncodingConfig = true;
      configDir = "/data/.state/media/jellyfin";
      dataDir = "/data/.state/media/jellyfin/data";
      cacheDir = "/data/.state/media/jellyfin/cache";
      logDir = "/data/.state/media/jellyfin/log";
      group = "media";
      hardwareAcceleration = {
        enable = true;
        device = "/dev/dri/renderD128";
      };
    };

    seerr = {
      enable = true;
      openFirewall = true;
      package = unstablePkgs.seerr;
      configDir = "/data/.state/media/seerr";
      port = 5055;
    };
  };

  systemd.services.bazarr = {
    description = "bazarr";
    after = ["network.target"];
    wantedBy = ["multi-user.target"];

    serviceConfig = {
      Type = "simple";
      User = "bazarr";
      Group = "media";
      # Set UMask to 0002 so directories are created with group write permission (775)
      # This allows other services in the media group (like Jellyfin) to modify files
      UMask = "0002";
      SyslogIdentifier = "bazarr";
      ExecStart = pkgs.writeShellScript "start-bazarr" ''
        ${pkgs.bazarr}/bin/bazarr \
          --config '/data/.state/media/bazarr' \
          --port ${toString 6767} \
          --no-update True
      '';
      Restart = "on-failure";
      KillSignal = "SIGINT";
      SuccessExitStatus = "0 156";
    };
  };

  systemd.services.seerr = {
    environment.NODE_EXTRA_CA_CERTS = "/srv/ssl/caddy-root.crt";
    serviceConfig = {
      DynamicUser = lib.mkForce false;
      User = "seerr";
      Group = "media";
      ReadWritePaths = ["/data/.state/media/seerr"];
    };
  };

  networking.firewall.allowedTCPPorts = [6767];

  systemd.tmpfiles.rules = [
    "d /data/.state/media/bazarr 0774 bazarr media -"
    "d /data/.state/media/sonarr 0775 sonarr media -"
    "d /data/.state/media/radarr 0775 radarr media -"
    "d /data/.state/media/jellyfin 0775 jellyfin media -"
    "d /data/.state/media/jellyfin/data 0775 jellyfin media -"
    "d /data/.state/media/jellyfin/cache 0775 jellyfin media -"
    "d /data/.state/media/jellyfin/log 0775 jellyfin media -"
    "d /data/.state/media/seerr 0750 seerr seerr -"
  ];

  users = {
    groups.media.gid = 169;
    users.bazarr = {
      isSystemUser = true;
      group = "media";
      uid = 232;
    };
    users.seerr = {
      isSystemUser = true;
      group = "media";
    };
  };
}
