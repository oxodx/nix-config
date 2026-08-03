{lib, ...}: {
  imports = [
    ./boot.nix
    ./core.nix
    ./fhs.nix
    ./i18n.nix
    ./security.nix
    ./users.nix
  ];

  documentation.dev.enable = true;

  system.stateVersion = lib.mkDefault "26.05";

  zramSwap.enable = true;
}
