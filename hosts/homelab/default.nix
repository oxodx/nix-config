{
  lib,
  pkgs,
  mylib,
  myvars,
  disko,
  ...
}:
{
  imports = (mylib.scanPaths ./.) ++ [
    disko.nixosModules.default
  ];

  zramSwap.memoryPercent = lib.mkForce 100;

  networking = {
    hostName = "homelab";
    useDHCP = false;

    interfaces.wlan0 = {
      useDHCP = false;
      ipv4.addresses = [
        {
          address = "192.168.1.184";
          prefixLength = 24;
        }
      ];
    };

    defaultGateway = "192.168.1.1";
    nameservers = [
      "1.1.1.1"
      "8.8.8.8"
    ];

    networkmanager.enable = true;
  };

  system.stateVersion = "25.11";
}
