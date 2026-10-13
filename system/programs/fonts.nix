{pkgs, ...}: {
  fonts = {
    packages = with pkgs; [
      inter
      noto-fonts
      noto-fonts-cjk-sans
      jetbrains-mono
      cozette
      material-symbols
      nerd-fonts.symbols-only
      noto-fonts-color-emoji
    ];

    enableDefaultPackages = false;

    fontconfig = {
      enable = true;

      antialias = true;

      hinting = {
        enable = true;
        autohint = false;
        style = "slight";
      };

      subpixel = {
        lcdfilter = "default";
        rgba = "rgb";
      };

      defaultFonts = {
        serif = ["Noto Serif"];
        sansSerif = ["Inter" "Noto Sans"];
        monospace = ["JetBrains Mono" "Symbols Nerd Font" "Noto Sans Mono"];
        emoji = ["Noto Color Emoji"];
      };
    };

    fontDir = {
      enable = true;
      decompressFonts = true;
    };
  };
}
