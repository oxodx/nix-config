{
  description = "oxod's NixOS flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";

    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-index-db.url = "github:mic92/nix-index-database";
    nix-index-db.inputs.nixpkgs.follows = "nixpkgs";

    quickshell.url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
    quickshell.inputs.nixpkgs.follows = "nixpkgs";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    agenix.inputs.home-manager.follows = "home-manager";
    agenix.inputs.systems.follows = "systems";

    matugen.url = "github:iniox/matugen";
    matugen.inputs.nixpkgs.follows = "nixpkgs";
    matugen.inputs.systems.follows = "systems";

    llm-agents.url = "github:numtide/llm-agents.nix";
    llm-agents.inputs.nixpkgs.follows = "nixpkgs";
    llm-agents.inputs.systems.follows = "systems";

    # https://github.com/swornsystems/nix-zed-extensions
    zed-extensions.type = "github";
    zed-extensions.owner = "swornsystems";
    zed-extensions.repo = "nix-zed-extensions";
    zed-extensions.rev = "038c0432b922c9083fd4cd0fe7bf472994358c15";
    zed-extensions.inputs.nixpkgs.follows = "nixpkgs";

    systems.url = "github:nix-systems/default-linux";
  };

  outputs = {
    self,
    nixpkgs,
    systems,
    ...
  } @ inputs: let
    inherit (nixpkgs) lib;
    mylib = import ./lib {inherit lib;};

    forAllSystems = lib.genAttrs (import systems);
    pkgsFor = system:
      import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
  in {
    nixosConfigurations = import ./hosts {inherit self mylib inputs;};

    devShells = forAllSystems (system: let
      pkgs = pkgsFor system;
    in {
      default = pkgs.mkShell {
        packages = with pkgs; [
          git
          nil
          nixd
          alejandra
          lua-language-server
        ];
        name = "dots";
        env.DIRENV_LOG_FORMAT = "";
      };
    });

    formatter = forAllSystems (system: (pkgsFor system).alejandra);
  };
}
