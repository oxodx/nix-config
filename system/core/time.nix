{
  config,
  lib,
  ...
}: {
  time.hardwareClockInLocalTime = false;

  services.timesyncd = {
    enable = true;
    extraConfig = ''
      SaveIntervalSec=60
    '';
  };

  # The RTC is restored before login; NTP corrects the clock afterwards in the
  # background so an offline boot cannot delay or block the greeter.
  systemd.additionalUpstreamSystemUnits = ["systemd-time-wait-sync.service"];
  systemd.services.systemd-time-wait-sync = {
    wantedBy = lib.mkForce [];
    serviceConfig.TimeoutStartSec = "10s";
  };
  systemd.services.greetd = lib.mkIf config.services.greetd.enable {
    wants = ["time-sync.target"];
    after = ["time-set.target" "time-sync.target"];
    restartIfChanged = false;
  };
}
