{
  lib,
  modulesPath,
  pkgs,
  ...
}: {
  imports = [
    "${modulesPath}/virtualisation/proxmox-lxc.nix"
    ./services.nix
  ];

  networking = {
    dhcpcd.enable = false;
    hostName = "gawain-nixos";
    nameservers = ["1.1.1.1" "9.9.9.9"];
    useDHCP = false;
    useHostResolvConf = false;
  };

  services.resolved.enable = false;

  systemd.network = {
    enable = true;
    networks."50-eth0" = {
      matchConfig.Name = "eth0";
      addresses = [{Address = "192.168.1.41/24";}];
      dns = ["1.1.1.1" "9.9.9.9"];
      networkConfig = {
        DHCP = "ipv4";
        IPv6AcceptRA = true;
      };
      dhcpV4Config.UseDNS = false;
      linkConfig.RequiredForOnline = "routable";
    };
  };

  services.openssh.enable = true;

  systemd.services = {
    gawain-legacy-ip = {
      description = "Announce Gawain's legacy service address";
      wantedBy = ["network-online.target"];
      after = ["network-online.target"];
      wants = ["network-online.target"];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "-${pkgs.iputils}/bin/arping -U -c 5 -I eth0 192.168.1.41";
      };
    };
    register-nix-paths.environment.NIX_REMOTE = "local";
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  system.stateVersion = "26.05";
}
