{
  imports = [
    ./fish.nix
    ./fonts.nix
    ./qt.nix
    ./xdg.nix
    ./jellyfin.nix
  ];

  programs = {
    dconf.enable = true;
    nix-ld.enable = true;
    seahorse.enable = true;
  };
}
