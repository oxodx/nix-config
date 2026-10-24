{
  self,
  inputs,
  mylib,
  ...
}: let
  inherit (inputs.nixpkgs.lib) nixosSystem;
  mod = "${self}/system";
  home = "${self}/home";

  inherit (import "${self}/system") desktop laptop server;

  specialArgs = {
    inherit inputs self mylib;
  };
in {
  "oxod-laptop" = nixosSystem {
    inherit specialArgs;
    modules =
      laptop
      ++ [
        ./oxod-laptop
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

  "homelab-camelot" = nixosSystem {
    inherit specialArgs;
    modules =
      server
      ++ [
        ./homelab/camelot
      ];
  };

  "homelab-excalibur" = nixosSystem {
    inherit specialArgs;
    modules =
      server
      ++ [
        ./homelab/excalibur
      ];
  };

  "homelab-gawain" = nixosSystem {
    inherit specialArgs;
    modules =
      server
      ++ [
        ./homelab/gawain
      ];
  };
}
