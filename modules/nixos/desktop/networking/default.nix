{ ... }: {
  imports = [
    ./remote-desktop.nix
    ./tailscale.nix
    ./wireshark.nix
  ];
}
