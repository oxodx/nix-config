{
  imports = [
    ./gnome-services.nix
    ./location.nix
    ./pipewire.nix
  ];

  # smooth backlight control
  hardware.brillo.enable = true;

  services = {
    dbus.implementation = "broker";

    # profile-sync-daemon
    psd = {
      enable = true;
      resyncTimer = "10m";
    };
  };
}
