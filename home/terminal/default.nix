{config, ...}: let
  data = config.xdg.dataHome;
  conf = config.xdg.configHome;
  cache = config.xdg.cacheHome;
in {
  imports = [
    ./programs
    ./shell/starship.nix
    ./shell/zsh.nix
  ];

  programs.zoxide.enable = true;

  # add environment variables
  home.sessionVariables = {
    # clean up
    LESSHISTFILE = "${cache}/less/history";
    LESSKEY = "${conf}/less/lesskey";

    WINEPREFIX = "${data}/wine";
    XAUTHORITY = "$XDG_RUNTIME_DIR/Xauthority";

    EDITOR = "nvim --clean";
    DIRENV_LOG_FORMAT = "";

    # auto-run programs using nix-index-database
    NIX_AUTO_RUN = "1";
  };
}
