{
  pkgs,
  inputs,
  lib,
  ...
}: let
  quickshell = inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default;

  dependencies = with pkgs; [
    bash
    coreutils
    gawk
    lsof
    ripgrep
    procps
    util-linux
    imagemagick
    grim
    curl
    brightnessctl
  ];

  QML2_IMPORT_PATH = lib.concatStringsSep ":" [
    "${quickshell}/lib/qt-6/qml"
    "${pkgs.kdePackages.qtdeclarative}/lib/qt-6/qml"
    "${pkgs.kdePackages.kirigami.unwrapped}/lib/qt-6/qml"
  ];
in {
  users.users.oxod.packages = [quickshell];

  environment.sessionVariables.QML2_IMPORT_PATH = QML2_IMPORT_PATH;

  systemd.user.services.quickshell = {
    description = "Quickshell";
    partOf = [
      "tray.target"
      "graphical-session.target"
    ];
    after = ["graphical-session.target"];
    wantedBy = ["graphical-session.target"];

    serviceConfig = {
      Environment = "PATH=/run/wrappers/bin:${lib.makeBinPath dependencies} QML2_IMPORT_PATH=${QML2_IMPORT_PATH} QSG_RHI_BACKEND=vulkan";
      ExecStart = lib.getExe quickshell;
      Restart = "on-failure";
    };
  };
}
