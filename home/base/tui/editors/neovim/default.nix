{
  config,
  lib,
  pkgs,
  ...
}:
let
  shellAliases = {
    v = "nvim";
    vdiff = "nvim -d";
  };
  configPath = "${config.home.homeDirectory}/nix-config/home/base/tui/editors/neovim/nvim";
in
{
  xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink configPath;
  catppuccin.nvim.enable = false;

  home.shellAliases = shellAliases;
  programs.zsh.shellAliases = shellAliases;

  programs.neovim = {
    enable = true;
    package = pkgs.neovim-unwrapped;

    viAlias = true;
    vimAlias = true;

    extraWrapperArgs = with pkgs; [
      "--suffix"
      "LIBRARY_PATH"
      ":"
      "${lib.makeLibraryPath [
        stdenv.cc.cc
        zlib
      ]}"

      "--suffix"
      "PKG_CONFIG_PATH"
      ":"
      "${lib.makeSearchPathOutput "dev" "lib/pkgconfig" [
        stdenv.cc.cc
        zlib
      ]}"
    ];

    plugins = with pkgs.vimPlugins; [
      telescope-fzf-native-nvim
      nvim-treesitter.withAllGrammars
    ];
  };
}
