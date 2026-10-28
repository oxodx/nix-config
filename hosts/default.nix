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
  agenixModule = inputs.agenix.nixosModules.default;
  secretsModule = "${self}/secrets";

  specialArgs = {
    inherit inputs self mylib;
  };
in {
  "oxod-laptop" = nixosSystem {
    inherit specialArgs;
    modules =
      [agenixModule secretsModule]
      ++ laptop
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
      [agenixModule secretsModule]
      ++ desktop
      ++ [
        ./tv
        "${mod}/services/gnomeServices.nix"
        "${mod}/hardware/cpuAmdPstate.nix"
        "${home}"
      ];
  };

  "homelab-camelot" = nixosSystem {
    inherit specialArgs;
    modules = [agenixModule secretsModule] ++ server ++ [./homelab/camelot];
  };

  "homelab-excalibur" = nixosSystem {
    inherit specialArgs;
    modules = [agenixModule secretsModule] ++ server ++ [./homelab/excalibur];
  };

  "homelab-gawain" = nixosSystem {
    inherit specialArgs;
    modules = [agenixModule secretsModule] ++ server ++ [./homelab/gawain];
  };
}
