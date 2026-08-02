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

    # dolphin file explorer
    kdePackages.dolphin
    kdePackages.qtsvg
    kdePackages.kio
    kdePackages.kio-fuse
    kdePackages.kio-extras

    # audio
    amberol

    # images
    loupe

    # videos
    celluloid
    stremio-linux-shell

    # torrents
    transmission_4-gtk
  ];
}
