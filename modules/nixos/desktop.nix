{ pkgs, lib, ... }: {
  imports = [
    ./base
    ../base
  ];

  config = {
    services = {
      xserver.enable = false;
      greetd = {
        enable = true;
        settings = {
          default_session = {
            user = "oxod";
            command = "$HOME/.wayland-session";
          };
        };
      };
    };

    security.pam.services.swaylock = { };
  };
}
