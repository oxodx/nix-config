{
  pkgs,
  config,
  ...
}:
{
  imports = [
    ./servers/survival-01
  ];

  services.minecraft-servers = {
    enable = true;
    eula = true;
    openFirewall = true;
    dataDir = "/data/apps/minecraft/servers";
  };

  # Create Directories
  # https://www.freedesktop.org/software/systemd/man/latest/tmpfiles.d.html#Type
  systemd.tmpfiles.rules = [
    "d /data/apps/minecraft 0755 minecraft minecraft"
    "d /data/apps/minecraft/servers 0755 minecraft minecraft"
  ];
}
