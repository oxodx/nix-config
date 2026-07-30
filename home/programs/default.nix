{ pkgs, ... }:
{
  imports = [
    ./office

    ./gtk.nix
    ./media.nix
    ./qt.nix
    ./vicinae.nix
  ];

  home.packages = with pkgs; [
    halloy
    signal-desktop
    nheko

    gnome-calculator
    gnome-control-center

    overskride
    resources
    wineWow64Packages.wayland

    zotero
  ];
}
