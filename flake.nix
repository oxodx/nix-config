{
  description = "0x0D's nix config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixos-hardware.url = "github:0x0Dx/nixos-hardware";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nix-gaming, ... }@args:
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
          nixos-hardware = "${args.nixos-hardware}";
        };

        modules = [
          { nixpkgs.pkgs = pkgs; }
          home-manager.nixosModules.home-manager
          nix-gaming.nixosModules.pipewireLowLatency
          path
          ./users
          {
            config = {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
            };
          }
        ] ++ (readModules ./modules);
      };
    in
    {
      nixosConfigurations = {
        kumquat = makeHost ./hosts/kumquat;
      };
    };
}
