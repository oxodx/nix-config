{pkgs, ...}: let
  configFile = "fum/config.jsonc";
in {
  users.users.oxod.packages = with pkgs; [
    fum
    playerctl
  ];

  xdg.configFile."${configFile}".text = builtins.toJSON {
    players = [
      "zen"
      "zen-browser"
      "mozilla zen"
      "helium"
    ];
    debug = false;
    keybinds = {
      "esc;q" = "quit()";
      "h" = "prev()";
      "l" = "next()";
      " " = "play_pause()";
      "-" = "volume(-5)";
      "+" = "volume(+5)";
      "left" = "backward(2500)";
      "right" = "forward(2500)";
    };
    width = 60;
    height = 8;
    direction = "horizontal";
    layout = [
      {
        type = "cover-art";
        width = 20;
        height = 20;
      }
      {
        type = "empty";
        size = 4;
      }
      {
        type = "container";
        direction = "vertical";
        children = [
          {
            type = "label";
            text = "󰝚 $title";
            fg = "blue";
          }
          {
            type = "label";
            text = "󰠃 $artists";
            fg = "gray";
          }
          {
            type = "label";
            text = " $album";
            fg = "gray";
          }
          {
            type = "container";
            children = [];
          }
          {
            type = "container";
            height = 1;
            align = "center";
            flex = "center";
            children = [
              {
                type = "button";
                text = "󰒮";
                action = "prev()";
              }
              {
                type = "empty";
                size = 3;
              }
              {
                type = "button";
                text = "$status-icon";
                action = "play_pause()";
              }
              {
                type = "empty";
                size = 3;
              }
              {
                type = "button";
                text = "󰒭";
                action = "next()";
              }
            ];
          }
          {
            type = "progress";
            progress = {
              char = "━";
              fg = "magenta";
            };
            empty = {
              char = "─";
            };
          }
          {
            type = "container";
            flex = "space-between";
            height = 1;
            children = [
              {
                type = "button";
                text = "$position";
              }
              {
                type = "button";
                text = "var($len-style, $length)";
                action = "toggle($len-style, $length, $remaining-length)";
              }
            ];
          }
        ];
      }
    ];
  };
}
