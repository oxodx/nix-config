{
  services = {
    tuned = {
      enable = true;
      settings.dynamic_tuning = true;
      ppdSupport = true;
      ppdSettings.main.default = "balanced";
    };

    logind.settings.Login.HandlePowerKey = "suspend";

    upower.enable = true;

    power-profiles-daemon.enable = false;
    tlp.enable = false;
  };
}
