{
  lib,
  pkgs,
  mylib,
  myvars,
  disko,
  ...
}:
let
  hostName = "homelab";
in
{
  imports = (mylib.scanPaths ./.) ++ [
    disko.nixosModules.default
    ./disko.nix
    ./hardware-configuration.nix
    ./preservation.nix
  ];

  networking = {
    hostName = "kumquat";

    networkmanager.enable = true;
    useDHCP = false;
  };

  system.stateVersion = "25.11";
}
