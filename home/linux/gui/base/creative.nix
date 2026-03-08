{ lib, pkgs, ... }:
{
  home.packages =
    with pkgs;
    [
      # creative
      # gimp      # image editing, I prefer using figma in browser instead of this one
      inkscape # vector graphics
      krita # digital painting
      musescore # music notation
      # reaper # audio production
      # sonic-pi # music programming

      # 2d game design
      # aseprite # Animated sprite editor & pixel art tool

      # this app consumes a lot of storage, so do not install it currently
      # kicad     # 3d printing, electrical engineering

      # Astronomy
      stellarium # See what you can see with your eyes, binoculars or a small telescope.
      celestia # Real-time 3D simulation of space, travel throughout the solar system.
    ]
    ++ (lib.optionals pkgs.stdenv.isx86_64 [
      blender
      ldtk
    ]);

  programs = {
    obs-studio = {
      enable = pkgs.stdenv.isx86_64;
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-teleport
        droidcam-obs
        obs-vkcapture
        obs-gstreamer
        input-overlay
        obs-multi-rtmp
        obs-source-clone
        obs-shaderfilter
        obs-source-record
        obs-livesplit-one
        looking-glass-obs
        obs-vintage-filter
        obs-command-source
        obs-move-transition
        obs-backgroundremoval
        obs-pipewire-audio-capture
        obs-vaapi
        obs-3d-effect
      ];
    };
  };
}
