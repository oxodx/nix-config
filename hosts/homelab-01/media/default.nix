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

    downloadarr.qbittorrent = {
      removeCompletedDownloads = true;
      removeFailedDownloads = true;
    };

    nginx.enable = false;
    postgres.enable = true;

    recyclarr = {
      enable = true;
      cleanupUnmanagedProfiles.enable = true;
    };
  };
}
