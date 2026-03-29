{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # pulseaudio removed - pipewire-pulse provides pactl/pacmd
  ];

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;

    extraConfig.pipewire = {
      "10-clock-quantum" = {
        "context.properties" = {
          "default.clock.rate" = 48000;
          "default.clock.quantum" = 512;
          "default.clock.min-quantum" = 512;
          "default.clock.max-quantum" = 1024;
        };
      };
    };

    extraConfig.pipewire-pulse = {
      "10-pulse-quantum" = {
        "pulse.min.quantum" = "512/48000";
      };
    };
  };
  security.rtkit.enable = true;
  services.pulseaudio.enable = false;

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  services = {
    printing.enable = true;
    geoclue2.enable = true;

    udev.packages = with pkgs; [
      gnome-settings-daemon
    ];

    keyd = {
      enable = true;
      keyboards.default.settings = {
        main = {
          capslock = "overload(control, esc)";
          esc = "capslock";
        };
      };
    };
  };
}
