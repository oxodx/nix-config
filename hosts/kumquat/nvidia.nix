{ config, lib, pkgs, ... }: {
  boot.kernelParams = [
    "nvidia-drm.fbdev=1"
  ];
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    open = true;
    nvidiaSettings = true;

    # https://github.com/NixOS/nixpkgs/issues/489947
    # Apply CachyOS kernel 6.19 patch to NVIDIA latest driver
    package =
      let
        base = config.boot.kernelPackages.nvidiaPackages.latest;
        cachyos-nvidia-patch = pkgs.fetchpatch {
          url = "https://raw.githubusercontent.com/CachyOS/CachyOS-PKGBUILDS/master/nvidia/nvidia-utils/kernel-6.19.patch";
          sha256 = "sha256-YuJjSUXE6jYSuZySYGnWSNG5sfVei7vvxDcHx3K+IN4=";
        };

        driverAttr = if config.hardware.nvidia.open then "open" else "bin";
      in
      base
      // {
        ${driverAttr} = base.${driverAttr}.overrideAttrs (oldAttrs: {
          patches = (oldAttrs.patches or [ ]) ++ [ cachyos-nvidia-patch ];
        });
      };

    modesetting.enable = true;
    powerManagement.enable = true;

    dynamicBoost.enable = lib.mkForce true;
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
