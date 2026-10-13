{
  inputs,
  pkgs,
  ...
}: {
  users.users.oxod.packages = with pkgs; [
    # archives
    zip
    unzip
    unrar
    ouch

    # misc
    libnotify
    fontconfig
    fastfetch

    # utils
    dust
    duf
    fd
    file
    killall
    jq
    ps_mem

    gtt
    meteor-git
    nix-search-tv
    opencode
    gemini-cli
    codex
  ];
}
