{
  pkgs,
  mylib,
  ...
}: {
  imports = mylib.scanPaths ./.;

  home.packages = with pkgs; [
    libreoffice
    obsidian
    xournalpp
  ];
}
