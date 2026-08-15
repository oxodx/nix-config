{
  self,
  inputs,
  mylib,
  ...
}: let
  inherit (inputs.nixpkgs.lib) nixosSystem;

  homeImports = import "${self}/home/profiles";

  mod = "${self}/system";
  inherit (import mod) desktop laptop;

  specialArgs = {inherit self inputs mylib;};
in {
  "oxod-laptop" = nixosSystem {
    inherit specialArgs;
    modules =
      laptop
      ++ [
        ./oxod-laptop

        "${mod}/core/virtualisation.nix"
        "${mod}/hardware/nvidia.nix"
        "${mod}/programs/hyprland"
        "${mod}/programs/gamemode.nix"
        "${mod}/programs/games.nix"

        inputs.home-manager.nixosModules.home-manager
        {
          home-manager = {
            users.oxod.imports = homeImports."oxod@laptop";
            extraSpecialArgs = specialArgs;
            backupFileExtension = ".hm-backup";
          };
        }

        inputs.agenix.nixosModules.default
      ];
  };

  "homelab-01" = nixosSystem {
    inherit specialArgs;
    modules =
      desktop
      ++ [
        ./homelab-01

        "${mod}/core/virtualisation.nix"

        inputs.home-manager.nixosModules.home-manager
        {
          home-manager = {
            users.oxod.imports = homeImports."oxod@homelab-01";
            extraSpecialArgs = specialArgs;
            backupFileExtension = ".hm-backup";
          };
        }

        inputs.agenix.nixosModules.default
      ];
  };
}
