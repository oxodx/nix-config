{ pkgs, ... }:
{
  programs.yazi = {
    enable = true;
    package = pkgs.yazi;
    enableBashIntegration = true;
    enableZshIntegration = true;
    shellWrapperName = "yy";
    settings = {
      mgr = {
        show_hidden = true;
        sort_dir_first = true;
      };
    };
  };
}
