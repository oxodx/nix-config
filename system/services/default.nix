{pkgs, ...}: {
  imports = [
    ./location.nix
    ./pipewire.nix
    ./greetd.nix
  ];

  # smooth backlight control
  hardware.brillo.enable = true;

  services = {
    dbus.implementation = "broker";

    dbus.packages = with pkgs; [
      gcr
      gnome-settings-daemon
    ];

    # profile-sync-daemon
    psd = {
      enable = true;
      resyncTimer = "10m";
    };
  };
}
