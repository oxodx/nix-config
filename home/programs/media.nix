{pkgs, ...}: {
  programs.mpv = {
    enable = true;
    scripts = [pkgs.mpvScripts.mpris];
    config = {
      save-position-on-quit = true;
    };
  };

  home.packages = with pkgs; [
    # audio control
    pulsemixer
    pwvucontrol
    crosspipe

    # audio
    amberol

    # images
    loupe

    # videos
    mpv
    stremio-linux-shell

    # torrents
    transmission_4-gtk

    thunar
    xfconf
    thunar-archive-plugin
    thunar-volman
    gvfs
    tumbler
  ];
}
