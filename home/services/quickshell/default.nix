{
  pkgs,
  inputs,
  lib,
  config,
  ...
}: let
  quickshell = inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default;

  dependencies = with pkgs; [
    # Core system utils Quickshell calls directly via subprocesses
    which
    findutils
    bash
    coreutils
    gawk
    lsof
    ripgrep
    procps
    util-linux
    killall
    bc
    curl
    wget
    jq
    glib
    imagemagick

    # Icons & KDE dependencies
    kdePackages.breeze-icons
    hicolor-icon-theme
    kdePackages.kirigami
    kdePackages.kdialog
    kdePackages.syntax-highlighting
    kdePackages.bluedevil
    kdePackages.networkmanager-qt
    kdePackages.dolphin
    kdePackages.systemsettings
    kdePackages.xdg-desktop-portal-kde

    # Qt6 packages
    qt6.qt5compat
    qt6.qtpositioning
    qt6.qtimageformats
    qt6.qtmultimedia
    qt6.qtquicktimeline
    qt6.qtsensors
    qt6.qtsvg
    qt6.qttools
    qt6.qttranslations
    qt6.qtvirtualkeyboard
    qt6.qtwayland

    # Desktop tools & Hyprland utilities
    cava
    cliphist
    ddcutil
    upscayl
    vulkan-headers
    libdrm
    cpptrace
    jemalloc
    mesa
    playerctl
    geoclue2
    brightnessctl
    xdg-user-dirs
    matugen
    hyprland
    hyprsunset
    wl-clipboard
    libsecret
    networkmanager
    xdg-desktop-portal
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland
    clang
    uv
    hyprshot
    slurp
    swappy
    tesseract
    wf-recorder
    wtype
    ydotool
    fuzzel
    hypridle
    hyprlock
    hyprpicker
    songrec
    translate-shell
    wlogout
    libqalculate
    pulseaudio
  ];

  QML2_IMPORT_PATH = lib.concatStringsSep ":" [
    "${quickshell}/lib/qt-6/qml"
    "${pkgs.qt6.qt5compat}/lib/qt-6/qml"
    "${pkgs.qt6.qtpositioning}/lib/qt-6/qml"
    "${pkgs.kdePackages.qtdeclarative}/lib/qt-6/qml"
    "${pkgs.kdePackages.kirigami.unwrapped}/lib/qt-6/qml"
    "${pkgs.kdePackages.syntax-highlighting}/lib/qt-6/qml"
  ];

  xdgDataDirs = lib.concatStringsSep ":" [
    "${config.home.homeDirectory}/.nix-profile/share"
    "/etc/profiles/per-user/${config.home.username}/share"
    "/run/current-system/sw/share"
    "${pkgs.kdePackages.breeze-icons}/share"
    "${pkgs.hicolor-icon-theme}/share"
  ];
in {
  home.packages = dependencies ++ [quickshell];

  home.sessionVariables.QML2_IMPORT_PATH = QML2_IMPORT_PATH;

  systemd.user.services.quickshell = {
    Unit = {
      Description = "Quickshell Desktop Shell";
      PartOf = [
        "tray.target"
        "graphical-session.target"
      ];
      After = "graphical-session.target";
    };

    Service = {
      ExecStartPre = "${pkgs.bash}/bin/bash -c 'systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP HYPRLAND_INSTANCE_SIGNATURE XDG_DATA_DIRS'";
      ExecStart = "${pkgs.bash}/bin/bash -c '${lib.getExe quickshell}'";

      Environment = [
        "QSG_RHI_BACKEND=vulkan"
        "QML2_IMPORT_PATH=${QML2_IMPORT_PATH}"
        "QT_PLUGIN_PATH=${pkgs.qt6.qtbase}/lib/qt-6/plugins:${pkgs.kdePackages.kirigami}/lib/qt-6/plugins"
        "PATH=${lib.makeBinPath dependencies}:${config.home.homeDirectory}/.nix-profile/bin:/run/current-system/sw/bin"
        "XDG_DATA_DIRS=${xdgDataDirs}:%h/.local/share/flatpak/exports/share:/var/lib/flatpak/exports/share"
      ];

      Restart = "on-failure";
    };

    Install.WantedBy = ["graphical-session.target"];
  };
}
