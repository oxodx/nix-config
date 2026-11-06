{
  pkgs,
  inputs,
  lib,
  ...
}: let
  quickshell = inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default;

  # What the end-4 shell calls at runtime: notifications, Wi-Fi, clipboard history, the
  # wallpaper-based colour theme, the blue-light filter, screen recording and screenshots.
  dependencies = with pkgs; [
    bash
    coreutils
    gawk
    procps
    util-linux
    ripgrep
    lsof
    imagemagick
    grim
    slurp
    curl
    libnotify
    networkmanager
    wl-clipboard
    cliphist
    brightnessctl
    ddcutil
    # Wallpaper switching: the picker (kdialog), JSON parsing (jq), gsettings, video
    # wallpapers (mpvpaper) and thumbnails (ffmpeg).
    jq
    glib
    kdePackages.kdialog
    ffmpeg
    mpvpaper
    libsecret
    libqalculate
    playerctl
    cava
    matugen
    hyprsunset
    wf-recorder
  ];

  QML2_IMPORT_PATH = lib.concatStringsSep ":" [
    "${quickshell}/lib/qt-6/qml"
    "${pkgs.kdePackages.qtdeclarative}/lib/qt-6/qml"
    "${pkgs.kdePackages.kirigami.unwrapped}/lib/qt-6/qml"
    # Qt5Compat.GraphicalEffects, used by the end-4 shell's effects and shadows.
    "${pkgs.kdePackages.qt5compat}/lib/qt-6/qml"
    # org.kde.syntaxhighlighting, used by the code view in the sidebar.
    "${pkgs.kdePackages.syntax-highlighting}/lib/qt-6/qml"
    # QtPositioning, used by the weather widget.
    "${pkgs.kdePackages.qtpositioning}/lib/qt-6/qml"
  ];
in {
  # Also on your login PATH, so `which matugen` and the shell's helpers agree.
  users.users.oxod.packages = [quickshell] ++ dependencies;

  environment.sessionVariables = {
    QML2_IMPORT_PATH = QML2_IMPORT_PATH;
    QML_IMPORT_PATH = QML2_IMPORT_PATH;
  };

  systemd.user.services.quickshell = {
    description = "Quickshell";
    wantedBy = ["graphical-session.target"];
    partOf = ["graphical-session.target"];
    after = ["graphical-session.target"];

    serviceConfig = {
      Environment = "PATH=/run/wrappers/bin:${lib.makeBinPath dependencies} QML2_IMPORT_PATH=${QML2_IMPORT_PATH} QSG_RHI_BACKEND=vulkan";
      ExecStart = lib.getExe quickshell;
      Restart = "on-failure";
    };
  };
}
