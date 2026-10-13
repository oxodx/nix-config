{pkgs, ...}: {
  users.users.oxod.packages = with pkgs; [
    bibata-cursors
    adwaita-icon-theme
    (whitesur-icon-theme.override {
      boldPanelIcons = true;
      alternativeIcons = true;
    })
    gsettings-desktop-schemas
    xdg-user-dirs
    adw-gtk3
  ];

  environment.sessionVariables = {
    XDG_ICON_DIR = "${pkgs.whitesur-icon-theme}/share/icons/WhiteSur";
    GSETTINGS_SCHEMA_DIR = "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}/glib-2.0/schemas";
    XCURSOR_THEME = "Bibata-Original-Ice";
    XCURSOR_SIZE = "20";
    QS_ICON_THEME = "Adwaita";
  };

  environment.etc."xdg/gtk-3.0/bookmarks".text = ''
    file:///home/oxod/Downloads Downloads
    file:///home/oxod/Documents Documents
    file:///home/oxod/dev Dev
    file:///home/oxod/Music Music
    file:///home/oxod/Pictures Pictures
    file:///home/oxod/Videos Videos
  '';
}
