{pkgs, ...}: {
  imports = [
    ./tailscale.nix
  ];

  networking = {
    nameservers = [
      "192.168.1.41"
      "9.9.9.9"
      "1.1.1.1"
      "1.0.0.1"
    ];

    nftables.enable = true;

    networkmanager = {
      enable = true;
      dns = "none";
      # The RTL8852BE has severe latency spikes when NetworkManager enables
      # Wi-Fi power saving. Keep full performance while associated.
      wifi.powersave = false;
      plugins = with pkgs; [
        networkmanager-openvpn
      ];
    };

    useDHCP = false;
    dhcpcd.enable = false;
  };

  services = {
    openssh = {
      enable = true;
      settings.UseDns = true;
    };
  };

  systemd.services.NetworkManager-wait-online.serviceConfig.ExecStart = ["" "${pkgs.networkmanager}/bin/nm-online -q"];
  environment.etc.hosts.enable = false;
}
