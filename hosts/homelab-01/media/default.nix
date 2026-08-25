{
  lib,
  pkgs,
  mylib,
  config,
  ...
}: let
  vars = import ./_variables.nix;
in {
  imports = mylib.scanPaths ./.;

  hardware.graphics = {
    extraPackages = with pkgs; [
      intel-media-driver
      intel-vaapi-driver
      libva-vdpau-driver
      libvpl
    ];
  };

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "i965";
  };

  nixflix = {
    enable = true;
    stateDir = "/var/lib";
    mediaDir = "/mnt/media";
    downloadsDir = "/mnt/media/downloads";
    mediaUsers = ["oxod"];

    theme = {
      enable = true;
      name = "overseerr";
    };

    vpn = {
      enable = true;
      wgConfFile = vars.secrets.vpn;
      accessibleFrom = ["192.168.1.0/24"];
    };

    nginx.enable = false;
    postgres.enable = true;

    recyclarr = {
      enable = true;
      cleanupUnmanagedProfiles.enable = true;
    };

    sonarr = {
      enable = true;
      openFirewall = true;
      config = {
        apiKey._secret = "/root/secrets/sonarr/api_key";
        hostConfig.password._secret = "/root/secrets/sonarr/password";
      };
    };

    radarr = {
      enable = true;
      openFirewall = true;
      config = {
        apiKey._secret = "/root/secrets/radarr/api_key";
        hostConfig.password._secret = "/root/secrets/radarr/password";
      };
    };

    prowlarr = {
      enable = true;
      openFirewall = true;
      config = {
        apiKey._secret = "/root/secrets/prowlarr/api_key";
        hostConfig.password._secret = "/root/secrets/prowlarr/password";
      };
    };

    seerr = {
      enable = true;
      openFirewall = true;
      apiKey._secret = "/root/secrets/seerr/api_key";
    };

    torrentClients.qbittorrent = {
      enable = true;
      vpn.enable = true;
      openFirewall = true;
      password._secret = "/root/secrets/qbittorrent/password";
      serverConfig = {
        Preferences.WebUI = {
          Username = "oxod";
          Password_PBKDF2 = "@ByteArray(cUJpdHRvcnJlbnQ=:RMITXNabieBgLLQI01vv3wrdVeiq2MN2OV0lLkQiM8s=)";
        };
      };
    };
  };

  networking.firewall.allowedTCPPorts = [8282];
}
