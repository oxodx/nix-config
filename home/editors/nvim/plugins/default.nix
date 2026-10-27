{
  lib,
  pkgs,
  ...
}: let
  snippetDir = ../snippets;
  snippetFiles =
    lib.filterAttrs
    (name: type: type == "regular" && lib.hasSuffix ".snippets" name)
    (builtins.readDir snippetDir);
in {
  extraFiles =
    lib.mapAttrs'
    (name: _: lib.nameValuePair "custom-snippets/${name}" {source = snippetDir + "/${name}";})
    snippetFiles;

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
