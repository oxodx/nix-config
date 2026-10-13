{lib, ...}: {
  qt = {
    enable = lib.mkDefault true;
    platformTheme = lib.mkDefault "gnome";
    style = lib.mkDefault "adwaita-dark";
  };
}
