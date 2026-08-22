{
  config,
  lib,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ehci_pci"
    "ahci"
    "usbhid"
    "usb_storage"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-intel"];
  boot.extraModulePackages = [];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/589f5652-f26c-4047-a4c5-8ead6b4d9535";
    fsType = "ext4";
  };

  # nofail: a missing/changed media disk must not fail local-fs.target and
  # drop the host into emergency mode mid-rebuild (killing SSH sessions)
  fileSystems."/mnt/media" = {
    device = "/dev/disk/by-uuid/2b422eeb-dc37-42de-aee7-4157b71ae11a";
    fsType = "ext4";
    options = [
      "nofail"
      "x-systemd.device-timeout=5s"
    ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/9DFD-165E";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };

  swapDevices = [];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
