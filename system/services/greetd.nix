{pkgs, ...}: {
  services.greetd = {
    enable = true;
    settings = {
      terminal.vt = 1;
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-user-session --cmd ${pkgs.niri}/bin/niri-session";
        user = "greeter";
      };
    };
  };
}
