{pkgs, ...}: {
  eden = pkgs.callPackage ./eden {};
  rokit = pkgs.callPackage ./rokit {};
}
