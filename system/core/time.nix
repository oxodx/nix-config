{...}: {
  time.hardwareClockInLocalTime = false;

  services.timesyncd = {
    enable = true;
    extraConfig = ''
      SaveIntervalSec=60
    '';
  };

  # Restore the saved clock before login, then briefly allow NTP to catch up.
  # A failed/offline synchronization must not prevent access to the laptop.
  systemd.additionalUpstreamSystemUnits = ["systemd-time-wait-sync.service"];
  systemd.services.systemd-time-wait-sync = {
    wantedBy = ["sysinit.target"];
    serviceConfig.TimeoutStartSec = "30s";
  };
  systemd.services.greetd = {
    wants = ["time-sync.target"];
    after = ["time-set.target" "time-sync.target"];
    restartIfChanged = false;
  };
}
