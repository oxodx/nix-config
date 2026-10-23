{
  self,
  inputs,
  ...
}: let
  inherit (inputs.nixpkgs.lib) nixosSystem;
  mod = "${self}/system";
  home = "${self}/home";

  inherit (import "${self}/system") desktop laptop;

  specialArgs = {
    inherit inputs self;
  };
in {
  "oxod-laptop" = nixosSystem {
    inherit specialArgs;
    modules =
      laptop
      ++ [
        ./oxod-laptop
        "${mod}/core/time.nix"
        "${mod}/programs/games.nix"
        "${mod}/services/gnomeServices.nix"
        "${mod}/hardware/cpuAmdPstate.nix"
        "${mod}/hardware/asusBattery.nix"
        "${home}"
        "${home}/packages/wayland/niri"
        "${home}/services/quickshell"
      ];
  };

  "tv" = nixosSystem {
    inherit specialArgs;
    modules =
      desktop
      ++ [
        ./tv
        "${mod}/services/gnomeServices.nix"
        "${mod}/hardware/cpuAmdPstate.nix"
        "${home}"
      ];
  };
}
