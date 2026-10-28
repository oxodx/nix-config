{
  pkgs,
  mylib,
  ...
}: {
  imports = mylib.scanPaths ./.;

  users.users.oxod.packages = with pkgs; [
    alsa-utils
    easyeffects
  ];
}
