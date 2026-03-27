{
  pkgs,
  config,
  lib,
  ...
}:
{
  imports = [
    ./servers/survival01
  ];

  services.minecraft-servers = {
    enable = true;
    eula = true;
    openFirewall = true;
    dataDir = "/data/apps/minecraft/servers";
  };

  services.fail2ban = {
    enable = true;
    maxretry = 5;
    bantime = "24h";
    ignoreIP = [
      "10.0.0.0/8"
      "172.16.0.0/12"
      "192.168.0.0/16"
    ];
    jails = {
      sshd.enabled = false;
      minecraft = {
        enabled = true;
        filter = "minecraft";
        settings = {
          logpath = "/data/apps/minecraft/servers/logs/latest.log";
          port = "25581";
          maxretry = 5;
          findtime = "1m";
        };
      };
    };
  };

  environment.etc = {
    "fail2ban/filter.d/minecraft.conf".text = ''
      [Definition]
      failregex = ^<HOST>.*Lost connection$
      ignoreregex =
    '';
  };

  # Create Directories
  # https://www.freedesktop.org/software/systemd/man/latest/tmpfiles.d.html#Type
  systemd.tmpfiles.rules = [
    "d /data/apps/minecraft 0755 minecraft minecraft"
    "d /data/apps/minecraft/servers 0755 minecraft minecraft"
  ];
}
