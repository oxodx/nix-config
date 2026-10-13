{
  pkgs,
  lib,
  ...
}: let
  configFile = "mpv/mpv.conf";
in {
  users.users.oxod.packages = with pkgs; [
    mpv
    mpvScripts.mpris
  ];

  xdg.configFile."${configFile}".text =
    lib.generators.toKeyValue {
      mkKeyValue = k: v: "${lib.escapeShellArg k}=${lib.escapeShellArg v}";
      listsAsDuplicateKeys = true;
    } {
      profile = "gpu-hq";
      osc = "no";
      "osd-bar" = "no";
      volume = "100";
      "volume-max" = "200";
    };
}
