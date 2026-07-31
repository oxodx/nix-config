{
  lib,
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
