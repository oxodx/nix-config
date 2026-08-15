{pkgs, ...}: {
  imports = [
    ./office

    ./dev-tools.nix
    ./gtk.nix
    ./media.nix
    ./qt.nix
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
