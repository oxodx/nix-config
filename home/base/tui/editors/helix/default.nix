{
  config,
  pkgs,
  ...
}:
{
  # to make steel work, we need to git clone this repo to your home directory.
  home.sessionVariables.HELIX_STEEL_CONFIG = "${config.home.homeDirectory}/nix-config/home/base/tui/editors/helix/steel";

  home.packages = with pkgs; [
    steel
  ];

  programs.helix = {
    enable = true;
    settings = {
      editor = {
        line-number = "relative";
        cursorline = true;
        color-modes = true;
        lsp.display-messages = true;
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
        indent-guides.render = true;
      };
      keys.normal = {
        space = {
          space = "file_picker";
          w = ":w";
          q = ":q";
        };
        esc = [
          "collapse_selection"
          "keep_primary_selection"
        ];
      };
    };
  };
}
