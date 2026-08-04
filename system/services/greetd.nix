{pkgs, ...}: {
  services = {
    # https://wiki.archlinux.org/title/Greetd
    greetd = {
      enable = true;
      settings = {
        default_session = {
          user = "oxod";
          command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd $HOME/.wayland-session";
        };
      };
    };
  };

  # fix https://github.com/ryan4yin/nix-config/issues/10
  security.pam.services.swaylock = {};
}
