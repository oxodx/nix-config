{
  pkgs,
  mylib,
  ...
}: {
  imports = mylib.scanPaths ./.;

  users.users.oxod.packages = [pkgs.tor-browser];
}
