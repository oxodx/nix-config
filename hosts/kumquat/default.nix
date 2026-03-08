{
  config,
  lib,
  pkgs,
  nixos-hardware,
  ...
}:
{
  imports = [
    "${nixos-hardware}/asus/fa506ncr"
    ./hardware-configuration.nix
    ./nvidia.nix
  ];

  zramSwap.enable = lib.mkForce false;

  services.sunshine.enable = lib.mkForce true;
  services.tuned.ppdSettings.main.default = lib.mkForce "performance";

  networking = {
    hostName = "kumquat";

    networkmanager.enable = false;
    useDHCP = false;
  };

  networking.useNetworkd = true;
  systemd.network.enable = true;

  system.stateVersion = "25.11";
}
