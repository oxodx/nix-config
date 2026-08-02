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
    celluloid
    stremio-linux-shell

    # torrents
    transmission_4-gtk

    thunar
    xfconf
    xfce.thunar-archive-plugin
    xfce.thunar-volman
    gvfs
    tumbler
  ];
}
