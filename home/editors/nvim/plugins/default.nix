{pkgs, ...}: {
  extraFiles = {
    "custom-snippets/all.snippets".source = ../snippets/all.snippets;
    "custom-snippets/actionscript.snippets".source = ../snippets/actionscript.snippets;
    "custom-snippets/ada.snippets".source = ../snippets/ada.snippets;
    "custom-snippets/alpaca.snippets".source = ../snippets/alpaca.snippets;
    "custom-snippets/apache.snippets".source = ../snippets/apache.snippets;
    "custom-snippets/arduino.snippets".source = ../snippets/arduino.snippets;
    "custom-snippets/asm.snippets".source = ../snippets/asm.snippets;
    "custom-snippets/autoit.snippets".source = ../snippets/autoit.snippets;
    "custom-snippets/awk.snippets".source = ../snippets/awk.snippets;
    "custom-snippets/bash.snippets".source = ../snippets/bash.snippets;
    "custom-snippets/c.snippets".source = ../snippets/c.snippets;
    "custom-snippets/chef.snippets".source = ../snippets/chef.snippets;
    "custom-snippets/clojure.snippets".source = ../snippets/clojure.snippets;
    "custom-snippets/cmake.snippets".source = ../snippets/cmake.snippets;
    "custom-snippets/codeigniter.snippets".source = ../snippets/codeigniter.snippets;
    "custom-snippets/cpp.snippets".source = ../snippets/cpp.snippets;
    "custom-snippets/cs.snippets".source = ../snippets/cs.snippets;
    "custom-snippets/crystal.snippets".source = ../snippets/crystal.snippets;
    "custom-snippets/css.snippets".source = ../snippets/css.snippets;
    "custom-snippets/cuda.snippets".source = ../snippets/cuda.snippets;
    "custom-snippets/d.snippets".source = ../snippets/d.snippets;
    "custom-snippets/dart.snippets".source = ../snippets/dart.snippets;
    "custom-snippets/dart-flutter.snippets".source = ../snippets/dart-flutter.snippets;
    "custom-snippets/diff.snippets".source = ../snippets/diff.snippets;
    "custom-snippets/django.snippets".source = ../snippets/django.snippets;
  };

  extraConfigLua = ''
    require("luasnip.loaders.from_vscode").lazy_load()
    for _, path in ipairs(vim.api.nvim_get_runtime_file("custom-snippets", true)) do
      require("luasnip.loaders.from_snipmate").lazy_load({ paths = { path } })
    end
  '';

  imports = [
    ./bufferline.nix
    ./conform.nix
    ./gitsigns.nix
    ./indentBlankline.nix
    ./lsp.nix
    ./lualine.nix
    ./neotree.nix
    ./telescope.nix
    ./treesitter.nix
    ./whichKey.nix
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
    friendly-snippets.enable = true;
    comment.enable = true;
    luasnip.enable = true;

    blink-cmp = {
      enable = true;
      setupLspCapabilities = true;
      settings = {
        keymap = {
          preset = "default";
          "<Tab>" = ["snippet_forward" "select_next" "fallback"];
          "<S-Tab>" = ["snippet_backward" "select_prev" "fallback"];
        };
        appearance.nerd_font_variant = "mono";
        snippets.preset = "luasnip";
        completion = {
          documentation.auto_show = true;
          menu.border = "rounded";
          documentation.window.border = "rounded";
        };
        signature.enabled = true;
        sources.default = ["lsp" "path" "snippets" "buffer"];
      };
    };
  };
}
