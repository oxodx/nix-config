{ pkgs, ... }:
{
  fonts = {
    enableDefaultPackages = false;
    fontDir.enable = true;

    fontconfig = {
      defaultFonts = {
        serif = [
          "Source Serif 4"
          "Source Han Serif SC"
          "Source Han Serif TC"
        ];
        sansSerif = [
          "Source Sans 3"
          "LXGW WenKai Screen"
          "Source Han Sans SC"
          "Source Han Sans TC"
        ];
        monospace = [
          "Maple Mono NF CN"
          "Source Han Mono SC"
          "Source Han Mono TC"
          "JetBrainsMono Nerd Font"
        ];
        emoji = [ "Noto Color Emoji" ];
      };
      antialias = true;
      hinting.enable = false;
      subpixel = {
        rgba = "rgb";
      };
    };
  };

  # https://wiki.archlinux.org/title/KMSCON
  services.kmscon = {
    enable = true;
    fonts = with pkgs; [
      {
        name = "Maple Mono NF CN";
        package = maple-mono.NF-CN-unhinted;
      }
      {
        name = "JetBrainsMono Nerd Font";
        package = nerd-fonts.jetbrains-mono;
      }
    ];
    extraOptions = "--term xterm-256color";
    extraConfig = "font-size=14";
    hwRender = true;
  };
}
