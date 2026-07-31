{
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./variables.nix
  ];

  environment.pathsToLink = [ "/share/icons" ];

  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  # tell Electron/Chromium to run on Wayland
  environment.variables.NIXOS_OZONE_WL = "1";

  # Firefox/Thunderbird need GSettings schemas in XDG_DATA_DIRS to read
  # font/GTK settings (org.gnome.desktop.interface). Without them, UI text
  # renders invisible. See https://github.com/NixOS/nixpkgs/issues/546204
  environment.sessionVariables.XDG_DATA_DIRS = [
    "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}"
    "${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}"
  ];

  # write the Lua config
  environment.etc =
    let
      lua = [
        ./hyprland.lua
        ./settings.lua
        ./animations.lua
        ./binds.lua
        ./smartgaps.lua
      ];
    in
    builtins.listToAttrs (
      map (e: {
        name = "xdg/hypr/${lib.baseNameOf e}";
        value = {
          source = e;
        };
      }) lua
    );
}
