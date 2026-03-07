{ config, pkgs, lib, ... }: {
  config = {
    boot = {
      kernelPackages = pkgs.linuxPackages_6_12;
      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };
    };
  };
}
