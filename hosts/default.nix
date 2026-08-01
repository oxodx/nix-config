{
  self,
  inputs,
  ...
}: let
  inherit (inputs.nixpkgs.lib) nixosSystem;

  homeImports = import "${self}/home/profiles";

  mod = "${self}/system";
  inherit (import mod) laptop;

  specialArgs = {inherit inputs self;};
in {
  "oxod-laptop" = nixosSystem {
    specialArgs = {inherit inputs;};
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
}
