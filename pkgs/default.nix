{
  pkgs,
  inputs,
  ...
}: let
  unstable = import inputs.nixpkgs-unstable {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  };
in {
  eden = pkgs.callPackage ./eden {eden = unstable.eden;};
  rokit = pkgs.callPackage ./rokit {};
}
