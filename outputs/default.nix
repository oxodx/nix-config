{ self, nixpkgs, ... }@inputs:
let
  inherit (inputs.nixpkgs) lib;
  mylib = import ../lib { inherit lib; };

  genSpecialArgs =
    system:
    inputs // {
      inherit mylib;

      pkgs-stable = import inputs.nixpkgs-stable {
        inherit system;
        config.allowUnfree = true;
      };
      pkgs-master = import inputs.nixpkgs-master {
        inherit system;
        config.allowUnfree = true;
      };
      pkgs-x64 = import inputs.nixpkgs-x64 {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };
    };

  args = {
    inherit
      inputs
      lib
      mylib
      genSpecialArgs
      ;
  };

  nixosSystems = {
    x86_64-linux = import ./x86_64-linux (args // { system = "x86_64-linux"; });
    # aarch64-linux  = import ./aarch64-linux (args // { system = "aarch64-linux"; });
  };
  # darwinSystems = {
  # aarch64-darwin = import ./aarch64-darwin (args // { system = "aarch64-darwin"; });
  # };
  allSystems = nixosSystems; # // darwinSystems;
  allSystemNames = builtins.attrNames allSystems;
  nixosSystemValues = builtins.attrValues nixosSystems;
  # darwinSystemValues = builtins.attrValues darwinSystems;
  allSystemValues = nixosSystemValues; # ++ darwinSystemValues;

  forAllSystems = func: (nixpkgs.lib.genAttrs allSystemNames func);
in
{
  debugAttrs = {
    inherit
      nixosSystems
      # darwinSystems
      allSystems
      allSystemNames
      ;
  };

  nixosConfigurations = lib.attrsets.mergeAttrsList (
    map (it: it.nixosConfigurations or { }) nixosSystemValues
  );

  darwinConfigurations = lib.attrsets.mergeAttrsList (
    map (it: it.darwinConfigurations or { }) darwinSystemValues
  );

  checks = forAllSystems (system: {
    pre-commit-check = pre-commit-hooks.lib.${system}.run {
      src = mylib.relativeToRoot ".";
      hooks = {
        nixfmt-rfc-style = {
          enable = true;
          settings.width = 100;
        };
        typos = {
          enable = true;
          settings = {
            write = true;
            configPath = ".typos.toml";
            exclude = "rime-data/";
          };
        };
        prettier = {
          enable = true;
          settings = {
            write = true;
            configPath = ".prettierrc.yaml";
          };
        };
      };
    };
  });

  devShells = forAllSystems (
    system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      default = pkgs.mkShell {
        packages = with pkgs; [
          bashInteractive
          gcc
          nixfmt
          deadnix
          statix
          typos
          nodePackages.prettier
        ];
        name = "dots";
        inherit (self.checks.${system}.pre-commit-check) shellHook;
      };
    }
  );

  formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt);
}
