{ pkgs, ... }: {
  fonts.packages = with pkgs; [
    # Icon fonts
    material-design-icons
    font-awesome

    # Nerd fonts
    nerd-fonts.symbols-only
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    nerd-fonts.iosevka

    # Noto fonts
    noto-fonts
    noto-fonts-color-emoji

    # Source Fonts
    source-sans
    source-serif
    source-han-sans
    source-han-serif
    source-han-mono
  ];
}
