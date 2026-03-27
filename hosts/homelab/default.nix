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

  inherit (myvars.networking) mainGateway nameservers;
  inherit (myvars.networking.hostsAddr.${hostName}) iface ipv4;
  ipv4WithMask = "${ipv4}/24";
in
{
  imports = (mylib.scanPaths ./.) ++ [
    disko.nixosModules.default
  ];

  zramSwap.memoryPercent = lib.mkForce 100;

  networking = {
    inherit hostName;

    networkmanager.enable = false;
    useDHCP = false;
  };

  networking.useNetworkd = true;
  systemd.network.enable = true;

  systemd.network.networks."10-${iface}" = {
    matchConfig.Name = [ iface ];
    networkConfig = {
      Address = [ ipv4WithMask ];
      DNS = nameservers;
      DHCP = "ipv4";
      LinkLocalAddressing = "ipv4";
    };
    routes = [
      {
        Destination = "0.0.0.0/0";
        Gateway = mainGateway;
      }
    ];
    linkConfig.RequiredForOnline = "routable";
  };

  system.stateVersion = "25.11";
}
