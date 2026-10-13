{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./greetd.nix
    ./pipewire.nix
  ];

  services = {
    flatpak.enable = true;
    printing = {
      enable = true;
      drivers = [pkgs.hplip];
    };

    irqbalance.enable = true;
    thermald.enable = true;
    speechd.enable = lib.mkForce false;
  };
}
