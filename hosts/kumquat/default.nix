{ config, lib, pkgs, nixos-hardware, ... }: {
  imports = [
    "${nixos-hardware}/asus/fa506ncr"
    ./hardware-configuration.nix

    ../../modules/nixos/desktop.nix
  ];

  networking.hostName = "kumquat";
  networking.hostId = "f889ae0f";
  system.stateVersion = "25.11";

  services.xserver.videoDrivers = lib.mkDefault [ "nvidia" ];
}
