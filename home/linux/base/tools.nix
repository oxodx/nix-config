{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # misc
    libnotify
    wireguard-tools

    virt-viewer
  ];

  # auto mount usb drives
  services = {
    udiskie.enable = true;
    # syncthing.enable = true;
  };
}
