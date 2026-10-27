{pkgs, ...}: {
  imports = [
    ./conform.nix
    ./gitsigns.nix
    ./lsp.nix
    ./neotree.nix
    ./telescope.nix
    ./treesitter.nix
  ];

  extraPackages = with pkgs; [lazygit ripgrep fd wl-clipboard];

  plugins = {
    web-devicons.enable = true;
    nvim-autopairs.enable = true;
    sleuth.enable = true;
    todo-comments.enable = true;
    colorizer.enable = true;
    lazygit.enable = true;
    trouble.enable = true;

    comment.enable = true;

    blink-cmp = {
      enable = true;
      setupLspCapabilities = true;
      settings = {
        keymap.preset = "default";
        appearance.nerd_font_variant = "mono";
        completion = {
          documentation.auto_show = true;
          menu.border = "rounded";
          documentation.window.border = "rounded";
        };
        signature.enabled = true;
        sources.default = ["lsp" "path" "snippets" "buffer"];
      };
    };
    friendly-snippets.enable = true;

    which-key = {
      enable = true;
      settings = {
        delay = 250;
        preset = "modern";
        win.border = "rounded";
      };
    };

    bufferline = {
      enable = true;
      settings.options = {
        diagnostics = "nvim_lsp";
        always_show_bufferline = false;
        separator_style = "slant";
      };
    };

    lualine = {
      enable = true;
      settings.options = {
        theme = "catppuccin";
        globalstatus = true;
        component_separators = {
          left = "│";
          right = "│";
        };
        section_separators = {
          left = "";
          right = "";
        };
      };
    };

    indent-blankline = {
      enable = true;
      settings = {
        indent.char = "│";
        scope.enabled = true;
      };
    };
  };
}
