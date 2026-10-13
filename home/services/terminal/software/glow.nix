{pkgs, ...}: let
  configFile = "glow/glow.yml";
  toYAML = (pkgs.formats.yaml {}).generate;
in {
  users.users.oxod.packages = [pkgs.glow];
  xdg.configFile."${configFile}".source = toYAML "glow.yml" {
    style = "auto";
    mouse = false;
    pager = false;
    width = 80;
    all = false;
  };
}
