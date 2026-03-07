{ ... }: {
  services.tuned = {
    enable = true;
    settings.dynamic_tuning = true;
    ppdSupport = true;
    ppdSettings.main.default = "balanced";
  };
  services.upower.enable = true;

  services.power-profiles-daemon.enable = false;
  services.tlp.enable = false;
}
