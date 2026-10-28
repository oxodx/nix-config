{pkgs, ...}: {
  extraPackages = with pkgs; [alejandra stylua black shfmt prettier clang-tools];

  plugins.conform-nvim = {
    enable = true;
    settings = {
      notify_on_error = true;
      formatters.clang_format.prepend_args = [
        "--style={BasedOnStyle: Google, Language: Java, IndentWidth: 2, TabWidth: 2, UseTab: Never, ContinuationIndentWidth: 4, ColumnLimit: 120, BreakBeforeBraces: Attach, BreakBeforeBinaryOperators: None, AllowShortBlocksOnASingleLine: Never, AllowShortFunctionsOnASingleLine: None, AllowShortIfStatementsOnASingleLine: Never, AllowShortLoopsOnASingleLine: false, BinPackArguments: false, BinPackParameters: false, IndentCaseLabels: true, SortIncludes: Never}"
      ];
      formatters_by_ft = {
        nix = ["alejandra"];
        java = ["clang_format"];
        lua = ["stylua"];
        python = ["black"];

        bash = ["shfmt"];
        javascript = ["prettier"];
        javascriptreact = ["prettier"];
        typescript = ["prettier"];
        typescriptreact = ["prettier"];
        json = ["prettier"];
        yaml = ["prettier"];
        markdown = ["prettier"];
        html = ["prettier"];
        css = ["prettier"];
      };
    };
  };
}
