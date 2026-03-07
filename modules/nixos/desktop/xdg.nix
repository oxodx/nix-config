{ lib, pkgs, ... }: {
  xdg.terminal-exec = {
    enable = true;
    package = pkgs.xdg-terminal-exec;
    settings =
      let
        my_terminal_desktop = [
          "Alacritty.desktop"
          "kitty.desktop"
          "foot.desktop"
          "com.mitchellh.ghostty.desktop"
        ];
      in
      {
        GNOME = my_terminal_desktop ++ [
          "com.raggesilver.BlackBox.desktop"
          "org.gnome.Terminal.desktop"
        ];
        niri = my_terminal_desktop;
        default = my_terminal_desktop;
      };
  };

  xdg = {
    autostart.enable = lib.mkDefault true;
    menus.enable = lib.mkDefault true;
    mime.enable = lib.mkDefault true;
    icons.enable = lib.mkDefault true;
  };

  xdg.portal = {
    enable = true;

    config = {
      common = {
        default = [
          "gtk"
          "gnome"
        ];
      };
    };

    xdgOpenUsePortal = true;

    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-gnome
    ];
  };
}
