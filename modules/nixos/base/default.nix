{ ... }:
{
  imports = [
    ./networking
    ./btrbk.nix
    ./core.nix
    ./i18n.nix
    ./nix.nix
    ./packages.nix
    ./ssh.nix
    ./user-group.nix
    ./zram.nix
  ];
}
