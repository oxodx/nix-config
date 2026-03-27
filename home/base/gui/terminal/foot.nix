{ pkgs, ... }:
{
  programs.foot = {
    enable = pkgs.stdenv.isLinux;
    server.enable = true;

    settings = {
      main = {
        term = "foot";
        font = "Maple Mono NF CN:size=13";
        dpi-aware = "no";
        resize-keep-grid = "no";

        shell = "${pkgs.bash}/bin/bash --login -c 'zsh --login --interactive'";
      };

      mouse = {
        hide-when-typing = "yes";
      };
    };
  };
}
