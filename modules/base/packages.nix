{ pkgs, ... }:
{
  environment.variables.EDITOR = "nvim --clean";

  environment.systemPackages = with pkgs; [
    # Core tools
    nushell
    zsh
    fastfetch
    neovim
    gnumake
    go-task
    git
    git-lfs

    # System monitoring
    procs
    btop

    # Archives
    zip
    xz
    zstd
    unzipNLS
    p7zip

    # Text processing
    gnugrep
    gawk
    gnutar
    gnused
    sad

    # Networking tools
    mtr
    gping
    dnsutils
    ldns
    doggo
    wget
    curl
    curlie
    httpie
    aria2
    socat
    nmap
    ipcalc
    iperf3
    hyperfine
    tcpdump

    # File transfer
    rsync
    croc

    # Security
    libargon2
    openssl

    # Misc
    file
    which
    tree
    tealdeer

    # Other
    jq
    yq-go
    jc
    fzf
    fd
    findutils
    ripgrep
    duf
    dust
    gdu
    ncdu
  ];
}
