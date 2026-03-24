{ pkgs, pkgs-master, ... }:
{
  home.packages =
    with pkgs;
    [
      wireshark

      # IDEs
      jetbrains.idea-oss
    ]
    # AI Agent Tools
    ++ (with pkgs-master; [
      cursor-cli
      claude-code
      gemini-cli
      opencode
    ]);
}
