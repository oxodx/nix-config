{ self, nixpkgs, ... }@inputs:
let
  inherit (inputs.nixpkgs) lib;
  mylib = import ../lib { inherit lib; };
  myvars = import ../vars { inherit lib; };

  genSpecialArgs =
    system:
    inputs
    // {
      inherit mylib myvars;

      pkgs-stable = import inputs.nixpkgs-stable {
        inherit system;
        config.allowUnfree = true;
      };
      pkgs-master = import inputs.nixpkgs-master {
        inherit system;
        config.allowUnfree = true;
      };
      pkgs-x64 = import inputs.nixpkgs {
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

  # Colmena - remote deployment via SSH
  colmena = {
    meta =
      (
        let
          system = "x86_64-linux";
        in
        {
          # colmena's default nixpkgs & specialArgs
          nixpkgs = import nixpkgs { inherit system; };
          specialArgs = genSpecialArgs system;
        }
      )
      // {
        # per-node nixpkgs & specialArgs
        nodeNixpkgs = lib.attrsets.mergeAttrsList (
          map (it: it.colmenaMeta.nodeNixpkgs or { }) nixosSystemValues
        );
        nodeSpecialArgs = lib.attrsets.mergeAttrsList (
          map (it: it.colmenaMeta.nodeSpecialArgs or { }) nixosSystemValues
        );
      };
  }
  // lib.attrsets.mergeAttrsList (map (it: it.colmena or { }) nixosSystemValues);

  # darwinConfigurations = lib.attrsets.mergeAttrsList (
  #  map (it: it.darwinConfigurations or { }) darwinSystemValues
  # );

  checks = forAllSystems (system: {
    pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
      src = mylib.relativeToRoot ".";
      hooks = {
        pkgs.nixfmt = {
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
          prettier
        ];
        name = "dots";
        inherit (self.checks.${system}.pre-commit-check) shellHook;
      };
    }
  );

  formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt);
}
