-- Language servers. Mason downloads them on Linux and Windows, so nothing has to come from Nix.
-- Run :Mason to see or change them. Needs Neovim 0.11+ for vim.lsp.config.
local servers = {
  "bashls", "clangd", "cssls", "csharp_ls", "dockerls", "gopls", "harper_ls",
  "html", "jdtls", "lua_ls", "luau_lsp", "markdown_oxide", "neocmake", "phpactor",
  "pyright", "rust_analyzer", "tailwindcss", "ts_ls", "yamlls", "astro",
}

return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      "saghen/blink.cmp",
    },
    config = function()
      -- Completion capabilities from blink.cmp, for every server.
      local ok, blink = pcall(require, "blink.cmp")
      if ok then
        vim.lsp.config("*", { capabilities = blink.get_lsp_capabilities() })
      end

      -- Per-server settings.
      vim.lsp.config("lua_ls", {
        settings = { Lua = { telemetry = { enable = false } } },
      })

      vim.lsp.config("yamlls", {
        settings = { yaml = { schemaStore = { enable = false, url = "" } } },
      })

      vim.lsp.config("jdtls", {
        settings = {
          java = {
            completion = {
              favoriteStaticMembers = {
                "org.junit.jupiter.api.Assertions.*",
                "org.mockito.Mockito.*",
                "java.util.Objects.requireNonNull",
              },
            },
            configuration = { updateBuildConfiguration = "interactive" },
            contentProvider = { preferred = "fernflower" },
            eclipse = { downloadSources = true },
            maven = { downloadSources = true },
            implementationsCodeLens = { enabled = true },
            referencesCodeLens = { enabled = true },
            signatureHelp = { enabled = true },
          },
        },
      })

      vim.lsp.config("harper_ls", {
        settings = {
          ["harper-ls"] = {
            linters = {
              boring_words = true,
              linking_verbs = true,
              sentence_capitalization = false,
              spell_check = false,
            },
            codeActions = { forceStable = true },
          },
        },
      })

      -- Python: use the project's .venv when there is one.
      vim.lsp.config("pyright", {
        before_init = function(_, config)
          local venv_python = config.root_dir and (config.root_dir .. "/.venv/bin/python")
          if venv_python and vim.fn.executable(venv_python) == 1 then
            config.settings = config.settings or {}
            config.settings.python = config.settings.python or {}
            config.settings.python.pythonPath = venv_python
          end
        end,
      })

      -- Mason installs and enables these servers.
      require("mason").setup({ ui = { border = "rounded" } })
      require("mason-lspconfig").setup({
        ensure_installed = servers,
        automatic_enable = true,
      })

      -- Formatters and tools that conform.nvim and the linters call.
      require("mason-tool-installer").setup({
        ensure_installed = { "stylua", "shfmt", "prettier", "yapf", "clang-format", "cmakelang" },
        run_on_start = true,
      })

      -- QML / Quickshell. Mason does not ship qmlls, so it is only enabled when it is installed.
      -- Set QML_IMPORT_PATH (colon separated) to point it at your QML modules.
      if vim.fn.executable("qmlls") == 1 then
        local cmd = { "qmlls", "--no-cmake-calls" }
        for path in string.gmatch(vim.env.QML_IMPORT_PATH or "", "[^:]+") do
          table.insert(cmd, "-I")
          table.insert(cmd, path)
        end
        vim.lsp.config("qmlls", { cmd = cmd })
        vim.lsp.enable("qmlls")
      end
    end,
  },
}
