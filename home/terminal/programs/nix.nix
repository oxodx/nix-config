{pkgs, ...}: {
  home.packages = with pkgs; [
    deadnix
    nixfmt
    statix
    nil
    nixd
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableZshIntegration = true;
  };
}
