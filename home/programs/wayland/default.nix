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

  systemd.user.targets.tray.Unit.Requires = lib.mkForce ["graphical-session.target"];
}
