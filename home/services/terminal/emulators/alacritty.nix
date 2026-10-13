{pkgs, ...}: let
  configFile = "alacritty/alacritty.toml";
in {
  users.users.oxod.packages = with pkgs; [
    alacritty
  ];

  xdg.configFile."${configFile}".source = (pkgs.formats.toml {}).generate "alacritty.toml" {
    terminal.shell.program = "${pkgs.fish}/bin/fish";
    env.TERM = "xterm-256color";
    scrolling.multiplier = 5;
    selection.save_to_clipboard = true;
    font.size = 12;
  };
}
