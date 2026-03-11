{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # misc
    libnotify
    wireguard-tools

    virt-viewer

    devenv
  ];

  # auto mount usb drives
  services = {
    udiskie.enable = true;
    # syncthing.enable = true;
  };
}
