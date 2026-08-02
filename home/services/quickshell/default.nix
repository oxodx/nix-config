{
  pkgs,
  inputs,
  lib,
  ...
}: let
  quickshell = inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default;

  dependencies = with pkgs; [
    qt6.qt5compat
    qt6.qtpositioning
    kdePackages.syntax-highlighting
    bash
    coreutils
    gawk
    lsof
    ripgrep
    procps
    util-linux
  ];

  QML2_IMPORT_PATH = lib.concatStringsSep ":" [
    "${quickshell}/lib/qt-6/qml"
    "${pkgs.qt6.qt5compat}/lib/qt-6/qml"
    "${pkgs.qt6.qtpositioning}/lib/qt-6/qml"
    "${pkgs.kdePackages.qtdeclarative}/lib/qt-6/qml"
    "${pkgs.kdePackages.kirigami.unwrapped}/lib/qt-6/qml"
    "${pkgs.kdePackages.syntax-highlighting}/lib/qt-6/qml"
  ];
in {
  home.packages = [
    (pkgs.writeShellScriptBin "qs" ''
      exec ${pkgs.coreutils}/bin/env QML2_IMPORT_PATH="${QML2_IMPORT_PATH}" QSG_RHI_BACKEND=vulkan "${quickshell}/bin/qs" "$@"
    '')
  ];

  home.sessionVariables.QML2_IMPORT_PATH = QML2_IMPORT_PATH;

  systemd.user.services.quickshell = {
    Unit = {
      Description = "Quickshell";
      PartOf = [
        "tray.target"
        "graphical-session.target"
      ];
      After = "graphical-session.target";
    };
    Service = {
      Environment = "PATH=/run/wrappers/bin:${lib.makeBinPath dependencies} QML2_IMPORT_PATH=${QML2_IMPORT_PATH} QSG_RHI_BACKEND=vulkan";
      ExecStart = lib.getExe quickshell;
      Restart = "on-failure";
    };
    Install.WantedBy = ["graphical-session.target"];
  };
}
