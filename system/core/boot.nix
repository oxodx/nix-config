{pkgs, ...}: {
  boot = {
    initrd = {
      systemd.enable = true;
      supportedFilesystems = ["ext4"];
    };

    kernelPackages = pkgs.linuxPackages_latest;

    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
    };
  };
}
