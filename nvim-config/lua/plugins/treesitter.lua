-- Syntax highlighting, indentation, and code-aware text objects.
-- Needs a C compiler to build parsers (gcc or clang on Linux, MSVC or zig on Windows).
return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "bash", "c", "cpp", "css", "go", "html", "java", "javascript", "json",
          "lua", "markdown", "markdown_inline", "python", "query", "rust",
          "tsx", "typescript", "vim", "vimdoc", "yaml",
        },
        highlight = { enable = true },
        indent = { enable = true },
        textobjects = {
          select = { enable = true, lookahead = true },
        },
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "master",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
  { "nvim-treesitter/nvim-treesitter-context" },
}
