{
  pkgs,
  lib,
  mylib,
  ...
}: {
  imports = mylib.scanPaths ./.;

  home.packages = with pkgs; [
    # screenshot
    grim
    slurp

    # utils
    wl-clipboard
  ];

  # make stuff work on wayland
  home.sessionVariables = {
    QT_QPA_PLATFORM = "wayland;x11";
    XDG_SESSION_TYPE = "wayland";
  };

  home.file.".wayland-session" = {
    source = pkgs.writeScript "init-session" ''
      ${lib.getExe pkgs.uwsm} start hyprland.desktop
    '';
  };

  systemd.user.targets.tray.Unit.Requires = lib.mkForce ["graphical-session.target"];
}
