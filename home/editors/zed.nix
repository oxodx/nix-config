{
  programs.zed-editor = {
    enable = true;

    extensions = [
      "nix"
      "toml"
      "rust"
    ];

    userSettings = {
      hour_format = "hour24";
      auto_update = false;

      vim_mode = false;

      load_direnv = "shell_hook";
      base_keymap = "VSCode";

      theme = {
        mode = "system";
        light = "Ayu Light";
        dark = "Ayu Dark";
      };
    };
  };
}
