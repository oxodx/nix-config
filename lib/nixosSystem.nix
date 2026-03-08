{
  inputs,
  lib,
  system,
  genSpecialArgs,
  nixos-modules,
  home-modules ? [ ],
  specialArgs ? (genSpecialArgs system),
  ...
}:
let
  inherit (inputs) nixpkgs home-manager nixos-generators;
in
nixpkgs.lib.nixosSystem {
  inherit system specialArgs;
  modules =
    nixos-modules
    ++ [
      nixos-generators.nixosModules.all-formats
      { nixpkgs.config.allowUnfree = true; }
    ]
    ++ (lib.optionals ((lib.lists.length home-modules) > 0) [
      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.backupFileExtension = "home-manager.backup";

        home-manager.extraSpecialArgs = specialArgs;
        home-manager.users.oxod.imports = home-modules;
      }
    ]);
}
