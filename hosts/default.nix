{
  self,
  mylib,
  inputs,
  ...
}:
let
  inherit (inputs.nixpkgs.lib) nixosSystem;

  homeImports = import "${self}/home/profiles";

  systemDir = "${self}/system";

  mod = import "${self}/system" { inherit mylib; };
  inherit (mod) desktop laptop;

  specialArgs = { inherit self inputs mylib; };
in
{
  "oxod-laptop" = nixosSystem {
    inherit specialArgs;
    modules = laptop ++ [
      ./oxod-laptop

      "${systemDir}/core/virtualisation.nix"
      "${systemDir}/hardware/nvidia.nix"
      "${systemDir}/programs/hyprland"
      "${systemDir}/programs/gamemode.nix"
      "${systemDir}/programs/games.nix"

      inputs.home-manager.nixosModules.home-manager
      {
        home-manager = {
          users.oxod.imports = homeImports."oxod@laptop";
          extraSpecialArgs = specialArgs;
          backupFileExtension = ".hm-backup";
        };
      }
    ];
  };

  "homelab-01" = nixosSystem {
    inherit specialArgs;
    modules = desktop ++ [
      ./homelab-01

      "${systemDir}/core/virtualisation.nix"

      inputs.home-manager.nixosModules.home-manager
      {
        home-manager = {
          users.oxod.imports = homeImports."oxod@homelab-01";
          extraSpecialArgs = specialArgs;
          backupFileExtension = ".hm-backup";
        };
      }

      inputs.vpn-confinement.nixosModules.default
      "${self}/modules"
    ];
  };
}
