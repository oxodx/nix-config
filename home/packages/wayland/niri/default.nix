{
  pkgs,
  lib,
  ...
}: let
  toKDL = import ./toKDL.nix {inherit pkgs lib;};

  settings = import ./settings.nix;
  binds = import ./binds.nix {inherit pkgs lib;};
  rules = import ./rules.nix;
  niriConfig = toKDL.generate "config.kdl" (settings // {binds = binds;} // rules);
in {
  programs.niri.enable = true;
  qt.platformTheme = "qt5ct";

  environment = {
    etc."xdg/niri/config.kdl".text = builtins.readFile niriConfig;

    sessionVariables = {
      NIRI_CONFIG = "/etc/xdg/niri/config.kdl";
      SDL_VIDEODRIVER = "wayland";
      XDG_SESSION_TYPE = "wayland";
      XDG_CURRENT_DESKTOP = "niri:GNOME";
      XDG_SESSION_DESKTOP = "niri";
      WLR_RENDERER = "vulkan";
      GTK_USE_PORTAL = 1;
    };

    systemPackages = with pkgs; [
      brightnessctl
      fuzzel
      grim
      kdePackages.polkit-kde-agent-1
      networkmanagerapplet
      playerctl
      slurp
      swayidle
      swaylock
      wl-clipboard
      xwayland-satellite
    ];
  };
}
