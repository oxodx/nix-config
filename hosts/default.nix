{ self, inputs, ... }:
let
  inherit (inputs.nixpkgs.lib) nixosSystem;

  mod = "${self}/system";
  inherit (import mod) laptop;

  specialArgs = { inherit inputs self; };
in
{
  flake.nixosConfigurations."oxod-laptop" = nixosSystem {
    specialArgs = { inherit inputs; };
    modules = laptop ++ [
      ./oxod-laptop

      "${mod}/hardware/nvidia.nix"
      "${mod}/programs/gamemode.nix"
      "${mod}/programs/games.nix"

      inputs.home-manager.nixosModules.home-manager
      {
        home-manager = {
          users.oxod = import ./home.nix;
          extraSpecialArgs = specialArgs;
          backupFileExtension = ".hm-backup";
        };
      }

      inputs.agenix.nixosModules.default
    ];
  };
}
