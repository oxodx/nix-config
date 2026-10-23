{pkgs, ...}: {
  imports = [
    ./firefox.nix
  ];

  users.users.oxod.packages = [pkgs.tor-browser];
}
