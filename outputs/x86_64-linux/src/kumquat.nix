{
  inputs,
  lib,
  mylib,
  system,
  genSpecialArgs,
  niri,
  ...
}@args:
let
  name = "kumquat";
  base-modules = {
    nixos-modules =
      (map mylib.relativeToRoot [
        "modules/nixos/desktop.nix"
        "hosts/${name}"
      ])
      ++ [
        {
          modules.desktop.fonts.enable = true;
          modules.desktop.wayland.enable = true;
          modules.desktop.gaming.enable = true;
        }
      ];
    home-modules = map mylib.relativeToRoot [
      "home/hosts/linux/${name}.nix"
    ];
  };

  modules-niri = {
    nixos-modules = [
      { programs.niri.enable = true; }
    ]
    ++ base-modules.nixos-modules;
    home-modules = base-modules.home-modules;
  };
in
{
  nixosConfigurations = {
    "${name}-niri" = mylib.nixosSystem (modules-niri // args);
  };

  packages = {
    "${name}-niri" = inputs.self.nixosConfigurations."${name}-niri".config.formats.iso;
  };
}
