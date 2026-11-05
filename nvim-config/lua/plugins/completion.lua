-- Autocompletion (blink.cmp), snippets (LuaSnip), and the snippet collection.
return {
  {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    -- The regex helper needs make on Linux. Windows skips it.
    build = vim.fn.has("win32") == 0 and "make install_jsregexp" or nil,
    dependencies = { "rafamadriz/friendly-snippets" },
    config = function()
      -- VS Code style snippets from friendly-snippets.
      require("luasnip.loaders.from_vscode").lazy_load()
      -- The SnipMate snippets in custom-snippets/ next to this config.
      for _, path in ipairs(vim.api.nvim_get_runtime_file("custom-snippets", true)) do
        require("luasnip.loaders.from_snipmate").lazy_load({ paths = { path } })
      end
    end,
  },

  { "rafamadriz/friendly-snippets", lazy = true },

  {
    "saghen/blink.cmp",
    version = "1.*",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = { "L3MON4D3/LuaSnip", "rafamadriz/friendly-snippets" },
    opts = {
      keymap = {
        preset = "default",
        ["<CR>"] = { "accept", "fallback" },
        ["<Tab>"] = { "snippet_forward", "select_next", "fallback" },
        ["<S-Tab>"] = { "snippet_backward", "select_prev", "fallback" },
      },
      appearance = { nerd_font_variant = "mono" },
      snippets = { preset = "luasnip" },
      completion = {
        documentation = {
          auto_show = true,
          window = { border = "rounded" },
        },
        menu = { border = "rounded" },
      },
      signature = { enabled = true },
      sources = { default = { "lsp", "path", "snippets", "buffer" } },
    },
    opts_extend = { "sources.default" },
  },
}
