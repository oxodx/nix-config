{pkgs, ...}: {
  home.packages = with pkgs; [
    colmena
    tokei
    bun
    luajit
    go
    cmake
    gnumake
    ninja
    libGL

    # Database
    pgcli
    mongosh
    sqlite

    # Embedded development
    minicom

    # Ai related
    (python3.withPackages (ps:
      with ps; [
        huggingface-hub
        opencv4
      ]))
    yt-dlp

    # Misc
    devbox
    bfg-repo-cleaner
    k6
    exercism
    git-trim
    gitleaks

    # Python
    uv
  ];
}
