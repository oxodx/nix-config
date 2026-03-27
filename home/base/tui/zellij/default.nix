{ pkgs, ... }:
let
  shellAliases = {
    "zj" = "zellij";
  };
in
{
  programs.zellij = {
    enable = true;
    package = pkgs.zellij;
  };
  xdg.configFile."zellij/config.kdl".source = ./config.kdl;
  catppuccin.zellij.enable = false;

  programs.zsh.initContent = ''
    if [[ -z "$ZELLIJ" ]] && [[ -z "$INSIDE_EMACS" ]]; then
      if [[ -n "$ZELLIJ_AUTO_ATTACH" ]] && [[ "$ZELLIJ_AUTO_ATTACH" == "true" ]]; then
        zellij attach -c
      else
        zellij
      fi

      # Auto exit the shell session when zellij exit
      export ZELLIJ_AUTO_EXIT="false" # disable auto exit
      if [[ -n "$ZELLIJ_AUTO_EXIT" ]] && [[ "$ZELLIJ_AUTO_EXIT" == "true" ]]; then
        exit
      fi
    fi
  '';

  home.shellAliases = shellAliases;
  programs.zsh.shellAliases = shellAliases;
}
