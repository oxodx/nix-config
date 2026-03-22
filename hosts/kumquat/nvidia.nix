{
  config,
  lib,
  pkgs,
  ...
}:
{
  boot.kernelParams = [
    "nvidia-drm.fbdev=1"
  ];

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.beta;
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    dynamicBoost.enable = false;
  };

  hardware.nvidia-container-toolkit.enable = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.sunshine.settings = {
    max_bitrate = 20000;
    nvenc_preset = 3;
    nvenc_twopass = "full_res";
  };
}
