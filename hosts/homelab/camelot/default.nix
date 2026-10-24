{modulesPath, ...}: {
  imports = ["${modulesPath}/virtualisation/proxmox-lxc.nix"];

  networking = {
    dhcpcd.enable = false;
    useDHCP = false;
    useHostResolvConf = false;
  };

  systemd.network = {
    enable = true;
    networks."50-eth0" = {
      matchConfig.Name = "eth0";
      networkConfig = {
        DHCP = "ipv4";
        IPv6AcceptRA = true;
      };
      linkConfig.RequiredForOnline = "routable";
    };
  };

  networking.hostName = "camelot-nixos";

  system.stateVersion = "26.05";
}
