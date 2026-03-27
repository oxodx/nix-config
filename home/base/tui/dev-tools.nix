{ pkgs, pkgs-stable, ... }:
{
  home.packages = with pkgs; [
    colmena

    tokei

    # db related
    pgcli
    mongosh
    sqlite

    # embedded development
    minicom

    # ai related
    python313Packages.huggingface-hub
    python313Packages.modelscope
    yt-dlp

    # misc
    devbox
    bfg-repo-cleaner
    k6

    exercism

    git-trim
    gitleaks

    conda
  ];

  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;

      enableZshIntegration = true;
      enableBashIntegration = true;
    };
  };
}
