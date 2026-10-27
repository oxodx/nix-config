{inputs, ...}: {
  imports = [inputs.nixvim.nixosModules.nixvim];

  programs.nixvim = {
    enable = true;
    enableMan = false;
    nixpkgs.config.allowUnfree = true;

    imports = [
      ./options.nix
      ./keymappings.nix
      ./plugins
    ];

    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };

    colorschemes.catppuccin = {
      enable = true;
      settings = {
        flavour = "mocha";
        transparent_background = false;
        integrations = {
          blink_cmp = true;
          gitsigns = true;
          native_lsp.enabled = true;
          neo_tree = true;
          telescope.enabled = true;
          treesitter = true;
          which_key = true;
        };
      };
    };
  };
}
