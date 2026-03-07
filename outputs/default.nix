{ self, nixpkgs, home-manager, nix-gaming, ... }@inputs:
let
  system = "x86_64-linux";
  pkgs = import nixpkgs {
    inherit system;
    config = { allowUnfree = true; };
  };
  lib = nixpkgs.lib;
  readModules = path: builtins.map (x: path + "/${x}") (builtins.attrNames (builtins.readDir path));
  makeHost = path: lib.nixosSystem {
    inherit system;

    specialArgs = {
      nixos-hardware = "${inputs.nixos-hardware}";
    };

    modules = [
      { nixpkgs.pkgs = pkgs; }
      home-manager.nixosModules.home-manager
      nix-gaming.nixosModules.pipewireLowLatency
      path
      ../users
      {
        config = {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
        };
      }
    ] ++ (readModules ../modules);
  };
in
{
  nixosConfigurations = {
    kumquat = makeHost ../hosts/kumquat;
  };
}
