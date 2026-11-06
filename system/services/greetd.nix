{pkgs, ...}: let
  hyprland = "${pkgs.uwsm}/bin/uwsm start -e -D Hyprland hyprland.desktop";
in {
  services.greetd = {
    enable = true;
    settings = {
      terminal.vt = 1;

      # Start Hyprland for oxod at boot, without a password prompt.
      initial_session = {
        command = hyprland;
        user = "oxod";
      };

      # After logging out, the login screen comes back.
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-user-session --cmd '${hyprland}'";
        user = "greeter";
      };
    };
  };
}
