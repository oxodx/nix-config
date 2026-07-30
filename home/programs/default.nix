{ pkgs, ... }:
{
  imports = [
    # ./media
    # ./gtk.nix
    # ./office
    # ./qt.nix
  ];

  home.packages = with pkgs; [
    halloy
    signal-desktop
    # telegram-desktop
    nheko

    gnome-calculator
    gnome-control-center

    overskride
    resources
    wineWow64Packages.wayland

    zotero
  ];
}
