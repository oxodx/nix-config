{ pkgs, ... }:
{
  home.packages =
    with pkgs;
    [
      mitmproxy
      wireshark

      # IDEs
      jetbrains.idea-oss

      # AI cli tools
      k8sgpt
      kubectl-ai
    ]
    ++ (lib.optionals pkgs.stdenv.isx86_64 [
      insomnia
    ]);
}
