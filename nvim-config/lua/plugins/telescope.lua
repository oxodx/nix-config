-- Fuzzy finding for files, text, buffers, and help.
return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        -- Needs a C compiler and make. Left out when make is not installed.
        build = vim.fn.executable("make") == 1 and "make" or nil,
        enabled = vim.fn.executable("make") == 1,
      },
    },
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        defaults = {
          vimgrep_arguments = {
            "rg", "-L", "--color=never", "--no-heading", "--with-filename",
            "--line-number", "--column", "--smart-case", "--fixed-strings",
          },
          selection_caret = "  ",
          entry_prefix = "  ",
          layout_strategy = "flex",
          layout_config = { horizontal = { prompt_position = "top" } },
          sorting_strategy = "ascending",
          file_ignore_patterns = { "^.git/", "^.mypy_cache/", "^__pycache__/", "^output/", "^data/", "%.ipynb" },
          set_env = { COLORTERM = "truecolor" },
        },
        pickers = {
          colorscheme = { enable_preview = true },
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
        },
      })
      pcall(telescope.load_extension, "fzf")
    end,
  },
}
