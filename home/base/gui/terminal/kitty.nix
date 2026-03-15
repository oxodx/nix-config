{ lib, pkgs, ... }:
{
  programs.kitty = {
    enable = true;
    font = {
      name = "Maple Mono NF CN";
      size = 13;
    };

    keybindings = {
      "ctrl+shift+m" = "toggle_maximized";
      "ctrl+shift+f" = "show_scrollback";
    };

    settings = {
      hide_window_decorations = "titlebar-and-corners";
      macos_show_window_title_in = "none";

      background_opacity = "0.93";
      macos_option_as_alt = true;
      enable_audio_bell = false;
      tab_bar_edge = "top";
      shell = "${pkgs.bash}/bin/bash --login -c 'nu --login --interactive'";
    };

    darwinLaunchOptions = [ "--start-as=maximized" ];
  };
}
