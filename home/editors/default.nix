{
  pkgs,
  mylib,
  ...
}: {
  imports = mylib.scanPaths ./.;

  users.users.oxod.packages = with pkgs; [
    jetbrains.idea
  ];
}
