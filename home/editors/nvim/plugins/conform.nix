{pkgs, ...}: {
  extraPackages = with pkgs; [alejandra stylua black shfmt prettier];

  plugins.conform-nvim = {
    enable = true;
    settings = {
      notify_on_error = true;
      format_on_save = {
        timeout_ms = 1000;
        lsp_format = "fallback";
      };
      formatters_by_ft = {
        nix = ["alejandra"];
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
