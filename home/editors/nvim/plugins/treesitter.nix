{
  plugins = {
    treesitter = {
      enable = true;
      indent.enable = true;
      highlight.enable = true;
      nixvimInjections = true;
    };

    treesitter-context.enable = true;

    treesitter-textobjects = {
      enable = true;
      settings.select = {
        enable = true;
        lookahead = true;
      };
    };
  };
}
