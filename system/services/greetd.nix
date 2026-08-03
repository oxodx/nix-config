{...}: {
  # greetd display manager with regreet greeter (password login)
  programs.regreet = {
    enable = true;

    settings = {
      commands = {
        reboot = ["systemctl" "reboot"];
        poweroff = ["systemctl" "poweroff"];
      };

      appearance.greeting_msg = "Welcome back!";
    };
  };

  services.greetd = {
    enable = true;
    # restart the greeter after the session ends
    restart = true;
  };

  # give the greeter direct access to the GPU
  users.users.greeter.extraGroups = ["video"];
}
