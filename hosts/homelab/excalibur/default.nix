{
  lib,
  modulesPath,
  pkgs,
  ...
}: {
  imports = [
    ../../../profiles/server.nix
    "${modulesPath}/virtualisation/proxmox-lxc.nix"
    ./docker.nix
  ];

  networking = {
    dhcpcd.enable = false;
    hostName = "excalibur-nixos";
    useDHCP = false;
    useHostResolvConf = false;
  };

  systemd.network = {
    enable = true;
    networks."50-eth0" = {
      matchConfig.Name = "eth0";
      addresses = [{Address = "192.168.1.206/24";}];
      networkConfig = {
        DHCP = "ipv4";
        IPv6AcceptRA = true;
      };
      linkConfig.RequiredForOnline = "routable";
    };
  };

  services.openssh.enable = true;

  systemd.services.excalibur-legacy-ip = {
    description = "Announce Excalibur's legacy service address";
    wantedBy = ["network-online.target"];
    after = ["network-online.target"];
    wants = ["network-online.target"];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "-${pkgs.iputils}/bin/arping -U -c 5 -I eth0 192.168.1.206";
    };
  };

  # The initial LXC import runs before nix-daemon and must not try to use it.
  systemd.services.register-nix-paths.environment.NIX_REMOTE = "local";

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  system.stateVersion = "26.05";
}
