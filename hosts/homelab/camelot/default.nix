{
  lib,
  pkgs,
  mylib,
  modulesPath,
  ...
}: {
  imports = [
    "${mylib.relativeToRoot}/profiles/server.nix"
    "${modulesPath}/virtualisation/proxmox-lxc.nix"
    ./services.nix
  ];

  networking = {
    dhcpcd.enable = false;
    useDHCP = false;
    useHostResolvConf = false;
  };

  systemd.network = {
    enable = true;
    networks."50-eth0" = {
      matchConfig.Name = "eth0";
      addresses = [
        {Address = "192.168.1.47/24";}
      ];
      networkConfig = {
        DHCP = "ipv4";
        IPv6AcceptRA = true;
      };
      linkConfig.RequiredForOnline = "routable";
    };
  };

  networking.hostName = "camelot-nixos";

  services.openssh.enable = true;

  systemd.services.camelot-legacy-ip = {
    description = "Announce Camelot's legacy service address";
    wantedBy = ["network-online.target"];
    after = ["network-online.target"];
    wants = ["network-online.target"];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "-${pkgs.iputils}/bin/arping -U -c 5 -I eth0 192.168.1.47";
    };
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  system.stateVersion = "26.05";
}
