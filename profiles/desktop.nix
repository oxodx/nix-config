{
  imports = [
    ./base.nix
    ../system/core/boot.nix
    ../system/core/limine.nix
    ../system/networking
    ../system/programs
    ../system/services
    ../system/hardware/fwupd.nix
    ../system/hardware/graphics.nix
  ];
}
