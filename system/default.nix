let
  server = [./nix];

  desktop = [
    ./core
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
