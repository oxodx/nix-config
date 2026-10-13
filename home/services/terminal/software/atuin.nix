{pkgs, ...}: let
  configFile = "atuin/config.toml";
  toTOML = (pkgs.formats.toml {}).generate;
in {
  users.users.oxod.packages = [
    pkgs.atuin
  ];

  xdg.configFile = {
    "${configFile}".source = toTOML "config.toml" {
      auto_sync = false;
      update_check = false;
      workspaces = false;
      ctrl_n_shortcuts = true;
      dialect = "uk";
      filter_mode = "host";
      search_mode = "skim";
      filter_mode_shell_up_key_binding = "session";
      style = "compact";
      inline_height = 7;
      show_help = false;
      enter_accept = true;
      history_filter = ["shit"];
      keymap_mode = "vim-normal";
      sync = {
        records = true;
      };
    };

    "fish/conf.d/atuin.fish".source =
      pkgs.runCommand "atuin-fish-init" {
        XDG_CONFIG_HOME = "$PWD";
        XDG_DATA_HOME = "$PWD";
        ATUIN_CONFIG_DIR = "$PWD/atuin";
      } ''
        mkdir -p atuin
        ${pkgs.atuin}/bin/atuin init fish --disable-up-arrow > $out
      '';
  };
}
