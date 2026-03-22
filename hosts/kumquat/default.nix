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

  services.sunshine.enable = false;
  services.tuned.ppdSettings.main.default = lib.mkForce "performance";

  networking = {
    hostName = "kumquat";

    networkmanager.enable = true;
    useDHCP = false;
  };

  modules.base.users.users = [
    "oxod"
    "nixos"
  ];

  networking.useNetworkd = true;
  systemd.network.enable = true;

  system.stateVersion = "25.11";
}
