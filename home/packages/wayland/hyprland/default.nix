{pkgs, ...}: let
  settings = import ./settings.nix;
  binds = import ./binds.nix {inherit pkgs;};
  rules = import ./rules.nix;

  hyprlandConfig = ''
    $mod = SUPER

    ${settings}

    source = ~/.config/hypr/binds.conf
    source = ~/.config/hypr/rules.conf
  '';
in {
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  qt.platformTheme = "qt5ct";

  environment = {
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
      MOZ_ENABLE_WAYLAND = "1";
      QT_QPA_PLATFORM = "wayland;xcb";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      SDL_VIDEODRIVER = "wayland";
      XDG_SESSION_TYPE = "wayland";
      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_DESKTOP = "Hyprland";
      GTK_USE_PORTAL = 1;
    };

    systemPackages = with pkgs; [
      brightnessctl
      fuzzel
      grim
      hyprpicker
      kdePackages.polkit-kde-agent-1
      networkmanagerapplet
      playerctl
      slurp
      swayidle
      wl-clipboard
    ];
  };

  xdg.configFile = {
    "hypr/hyprland.conf".text = hyprlandConfig;
    "hypr/binds.conf".text = binds;
    "hypr/rules.conf".text = rules;
  };
}
