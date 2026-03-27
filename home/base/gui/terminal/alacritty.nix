{ pkgs, ... }:
{
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        opacity = 0.93;
        startup_mode = "Maximized";
        dynamic_title = true;
        option_as_alt = "Both";
        decorations = "None";
      };
      scrolling = {
        history = 10000;
      };
      font = {
        bold = {
          family = "Maple Mono NF CN";
        };
        italic = {
          family = "Maple Mono NF CN";
        };
        normal = {
          family = "Maple Mono NF CN";
        };
        bold_italic = {
          family = "Maple Mono NF CN";
        };
        size = 13;
      };
      terminal = {
        shell = {
          program = "${pkgs.bash}/bin/bash";
          args = [
            "--login"
            "-c"
            "zsh --login --interactive"
          ];
        };
        osc52 = "CopyPaste";
      };
    };
  };
}
