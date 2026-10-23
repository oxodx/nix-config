{
  config,
  lib,
  pkgs,
  ...
}: let
  tunnelDevice = "sys-subsystem-net-devices-wg0\\x2dmullvad.device";
in {
  services.resolved.enable = true;
  networking.networkmanager.dns = lib.mkForce "systemd-resolved";

  # One DNS manager for NetworkManager, Mullvad and Tailscale. Start it
  # before either VPN attempts to publish its DNS configuration.
  systemd.services.mullvad-daemon = {
    requires = ["systemd-resolved.service"];
    after = ["systemd-resolved.service"];
  };
  systemd.services.tailscaled = {
    requires = ["systemd-resolved.service"];
    after = ["systemd-resolved.service"];
  };

  services.udev.extraRules = ''
    SUBSYSTEM=="net", ACTION=="add", KERNEL=="wg0-mullvad", TAG+="systemd", ENV{SYSTEMD_WANTS}+="mullvad-tailscale-pause.service"
  '';

  systemd.services.mullvad-tailscale-pause = lib.mkIf config.services.tailscale.enable {
    description = "Pause Tailscale while the Mullvad tunnel exists";
    bindsTo = [tunnelDevice];
    after = [tunnelDevice "tailscaled.service"];
    path = [pkgs.systemd pkgs.coreutils];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      RuntimeDirectory = "mullvad-tailscale-pause";
      RuntimeDirectoryMode = "0700";
    };
    script = ''
      if systemctl is-active --quiet tailscaled.service; then
        touch /run/mullvad-tailscale-pause/restore
        systemctl stop tailscaled.service
      fi
    '';
    preStop = ''
      if [ -e /run/mullvad-tailscale-pause/restore ]; then
        systemctl --no-block start tailscaled.service
      fi
    '';
  };
}
