{pkgs, ...}: {
  home.packages = with pkgs; [
    colmena
    tokei

    # Database
    pgcli
    mongosh
    sqlite

    # Embedded development
    minicom

    # Ai related
    python313Packages.huggingface-hub
    yt-dlp

    # Misc
    devbox
    bfg-repo-cleaner
    k6
    exercism
    git-trim
    gitleaks

    # Python
    python3
    uv
  ];
}
