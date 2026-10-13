{pkgs, ...}: let
  configFile = "lazygit/config.yml";
  toYAML = (pkgs.formats.yaml {}).generate;
in {
  users.users.oxod.packages = [pkgs.lazygit];
  xdg.configFile."${configFile}".source = toYAML "config.yml" {
    disableStartupPopups = true;
    git = {
      commit = {
        signOff = true;
      };
      parseEmoji = true;
    };
    gui = {
      nerdFontsVersion = "3";
      showBottomLine = false;
      showCommandLog = false;
      showListFooter = false;
      showRandomTip = false;
      theme = {
        activeBorderColor = ["magenta" "bold"];
        inactiveBorderColor = ["black"];
      };
    };
    notARepository = "skip";
    promptToReturnFromSubprocess = false;
    update = {
      method = "never";
    };
  };
}
