{
  programs.matugen = {
    enable = true;
    templates = {
      m3colors = {
        input_path = ./m3colors.json;
        output_path = "~/.local/state/quickshell/user/generated/colors.json";
      };
      hyprland = {
        input_path = ./hyprland.lua;
        output_path = "~/.config/hypr/hyprland/colors.lua";
      };
      hyprlock = {
        input_path = ./hyprlock.conf;
        output_path = "~/.config/hypr/hyprlock/colors.conf";
      };
      fuzzel = {
        input_path = ./fuzzel.ini;
        output_path = "~/.config/fuzzel/fuzzel_theme.ini";
      };
      gtk3 = {
        input_path = ./gtk3.css;
        output_path = "~/.config/gtk-3.0/gtk.css";
      };
      gtk4 = {
        input_path = ./gtk4.css;
        output_path = "~/.config/gtk-4.0/gtk.css";
      };
      kde_colors = {
        input_path = ./kde_colors.txt;
        output_path = "~/.local/state/quickshell/user/generated/color.txt";
      };
      wallpaper = {
        input_path = ./wallpaper.txt;
        output_path = "~/.local/state/quickshell/user/generated/wallpaper/path.txt";
      };
    };
  };
}
