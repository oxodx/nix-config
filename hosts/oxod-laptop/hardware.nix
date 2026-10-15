{
  lib,
  pkgs,
  config,
  inputs,
  modulesPath,
  ...
}: let
  pkgs-unstable = import inputs.nixpkgs-unstable {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  };
in {
  imports = [(modulesPath + "/installer/scan/not-detected.nix")];

  hardware.asus.battery = {
    chargeUpto = 90;
    enableChargeUptoScript = true;
  };

  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    open = true;
    nvidiaSettings = true;
    package = (pkgs-unstable.linuxPackagesFor config.boot.kernelPackages.kernel).nvidiaPackages.stable;
  };

  boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "usbhid" "usb_storage" "sd_mod"];
  boot.initrd.kernelModules = [];
  # The FA506NCR has no iGPU and its firmware only exposes s2idle. Without
  # NVIDIA S0ix support the dGPU never completes the suspend/resume cycle.
  boot.kernelParams = ["idle=nomwait"];
  # The in-kernel r8169 driver intermittently loses carrier with this
  # RTL8111/8168 (10ec:8168, rev 15). Use Realtek's r8168 driver instead.
  boot.kernelModules = ["kvm-amd" "r8168"];
  boot.extraModulePackages = [config.boot.kernelPackages.r8168];
  # Disable the Realtek power-saving features which cause carrier drops or a
  # live-looking link that stops passing traffic on this RTL8168H revision.
  # Set these when the driver loads so a later PHY reset cannot undo them.
  boot.extraModprobeConfig = ''
    options nvidia NVreg_EnableS0ixPowerManagement=1
    options r8168 eee_enable=0 eee_giga_lite=0 aspm=0 dynamic_aspm=0
    options rtw89_core disable_ps_mode=Y
    options rtw89_pci disable_clkreq=Y disable_aspm_l1=Y disable_aspm_l1ss=Y
  '';

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/6a39d7ba-5b08-42df-92ff-6534fe5db444";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/1812-34F1";
    fsType = "vfat";
    options = ["fmask=0077" "dmask=0077"];
  };

  swapDevices = [{device = "/dev/disk/by-uuid/e9cf2cd1-273e-4379-bc55-f9c0c05b2edb";}];

  boot.blacklistedKernelModules =
    ["r8169"]
    ++ lib.optionals (!config.hardware.enableRedistributableFirmware) ["ath3k"];

  services.tlp.enable = lib.mkDefault (!config.services.power-profiles-daemon.enable && !config.services.tuned.enable);
  services.fstrim.enable = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
