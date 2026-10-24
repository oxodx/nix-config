let
  server = [
    ./core
    ./nix
    ./programs/fish.nix
  ];

  desktop = [
    ./core
    ./core/boot.nix
    ./core/limine.nix
    ./networking
    ./nix
    ./programs
    ./services

    ./hardware/fwupd.nix
    ./hardware/graphics.nix
  ];

  laptop =
    desktop
    ++ [
      ./hardware/bluetooth.nix
      ./services/power.nix
    ];
in {
  inherit desktop laptop server;
}
