{
  description = "oxod's nixos configuration.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    nixvim.url = "github:nix-community/nixvim/nixos-26.05";
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    quickshell.url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
    quickshell.inputs.nixpkgs.follows = "nixpkgs";
    llm-agents.url = "github:numtide/llm-agents.nix";
  };

  outputs = {
    self,
    nixpkgs,
    systems,
    ...
  } @ inputs: let
    inherit (nixpkgs) lib;
    forAllSystems = lib.genAttrs (import systems);
    pkgsFor = system:
      import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
  in {
    lib = import ./lib {inherit lib;};

    nixosConfigurations = import ./hosts {inherit self inputs;};

    packages = forAllSystems (system:
      lib.filterAttrs (_: package: lib.meta.availableOn (pkgsFor system).stdenv.hostPlatform package) (import ./pkgs {
        pkgs = pkgsFor system;
        inherit inputs;
      }));

    devShells = forAllSystems (system: let
      pkgs = pkgsFor system;
    in {
      default = pkgs.mkShell {
        packages = with pkgs; [
          alejandra
          git
          inputs.agenix.packages.${system}.default
        ];
        name = "nixland";
        DIRENV_LOG_FORMAT = "";
      };
    });

    formatter = forAllSystems (system: let
      pkgs = pkgsFor system;
    in
      pkgs.writeShellApplication {
        name = "format";
        runtimeInputs = [pkgs.alejandra];
        text = ''
          if [ "$#" -eq 0 ]; then
            set -- .
          fi
          exec alejandra "$@"
        '';
      });
  };
}
