{
  pkgs,
  inputs,
  lib,
  mylib,
  config,
  ...
}: let
  quickshell = inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default;

  dependencies = with pkgs; [
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
    python
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
  home.packages = dependencies ++ [quickshell];

  home.sessionVariables.QML2_IMPORT_PATH = QML2_IMPORT_PATH;

  xdg.configFile."quickshell".source =
    config.lib.file.mkOutOfStoreSymlink "${mylib.relativeToRoot "home/services/quickshell"}";
}
