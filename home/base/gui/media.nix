{ pkgs, config, ... }:
{
  home.packages = with pkgs; [
    ffmpeg-full

    # images
    viu
    imagemagick
    graphviz
  ];
}
