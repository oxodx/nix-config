{
  lib,
  pkgs,
  ...
}: {
  boot.loader = {
    limine = {
      enable = true;
      efiSupport = true;
      style.wallpapers = [pkgs.nixos-artwork.wallpapers.simple-dark-gray-bootloader.gnomeFilePath];
      # Keep only the current entry until the graphics migration is stable.
      # Older generations are still retained by Nix and can be restored later.
      maxGenerations = 10;
      secureBoot.enable = false;
    };
    systemd-boot.enable = lib.mkForce false;
  };
}
