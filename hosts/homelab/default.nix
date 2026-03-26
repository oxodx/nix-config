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
  ];

  # Maximum total amount of memory that can be stored in the zram swap devices (as a percentage of your total memory).
  # Defaults to 1/2 of your total RAM. Run zramctl to check how good memory is compressed.
  # This doesn’t define how much memory will be used by the zram swap devices.
  zramSwap.memoryPercent = lib.mkForce 100;

  networking = {
    hostName = "homelab";

    networkmanager = {
      enable = true;
      dhcp = false;
      wifi.powersave = lib.mkDefault 2;

      connections = {
        # USB WiFi Dongle - Static IP
        "wlan0" = {
          ipv4.addresses = [
            {
              address = "192.168.1.184/24";
              gateway = "192.168.1.1";
            }
          ];
          ipv4.dns = [
            "1.1.1.1"
            "8.8.8.8"
          ];
        };
      };
    };
  };

  system.stateVersion = "25.11";
}
