{
  pkgs,
  lib,
  ...
}: let
  configFile = "bat/config";

  manPager = pkgs.writeShellScriptBin "manpager" ''
    ${pkgs.coreutils}/bin/col -bx | ${pkgs.bat}/bin/bat -l man -p "$@"
  '';
in {
  environment.sessionVariables = {
    MANPAGER = "${manPager}/bin/manpager";
    MANROFFOPT = "-c";
  };

  users.users.oxod.packages = with pkgs; [
    bat
    manPager
  ];

  xdg.configFile."${configFile}".text =
    lib.generators.toKeyValue {
      mkKeyValue = k: v: "--${lib.escapeShellArg k}=${lib.escapeShellArg v}";
      listsAsDuplicateKeys = true;
    } {
      pager = "less -FR";
      style = "plain";
      theme = "base16";
    };
}
