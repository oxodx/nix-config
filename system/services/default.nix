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

    gvfs.enable = true;
    tumbler.enable = true;
  };
}
