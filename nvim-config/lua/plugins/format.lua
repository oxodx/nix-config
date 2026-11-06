-- Formatting, run by <leader>cf. Each formatter must be on your PATH (see README).
return {
  {
    "stevearc/conform.nvim",
    cmd = "ConformInfo",
    opts = {
      notify_on_error = true,
      formatters = {
        clang_format = {
          prepend_args = {
            [[--style={BasedOnStyle: Google, Language: Java, IndentWidth: 2, TabWidth: 2, UseTab: Never, ContinuationIndentWidth: 4, ColumnLimit: 120, BreakBeforeBraces: Attach, BreakBeforeBinaryOperators: None, AllowShortBlocksOnASingleLine: Never, AllowShortFunctionsOnASingleLine: None, AllowShortIfStatementsOnASingleLine: Never, AllowShortLoopsOnASingleLine: false, BinPackArguments: false, BinPackParameters: false, IndentCaseLabels: true, SortIncludes: Never}]],
          },
        },
        yapf = {
          prepend_args = {
            "--style={based_on_style: pep8, indent_width: 2, continuation_indent_width: 2}",
          },
        },
      },
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "yapf" },
        java = { "clang_format" },
        bash = { "shfmt" },
        sh = { "shfmt" },
        cmake = { "cmake_format" },
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        html = { "prettier" },
        css = { "prettier" },
      },
    },
  },
}
