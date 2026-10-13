{
  inputs,
  pkgs,
  ...
}: {
  services = {
    logind.settings.Login = {
      powerKey = "suspend";
      lidSwitch = "suspend";
      lidSwitchExternalPower = "lock";
    };

    power-profiles-daemon = {
      enable = true;
      package = pkgs.power-profiles-daemon;
    };

    upower = {
      enable = true;
      percentageLow = 30;
      percentageCritical = 20;
      percentageAction = 10;
      criticalPowerAction = "PowerOff";
    };
  };

  systemd.sleep.settings.Sleep = {
    AllowSuspend = true;
    AllowHibernation = false;
    AllowSuspendThenHibernate = false;
    AllowHybridSleep = true;
  };
}
