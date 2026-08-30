{mylib, ...}: let
  desktop =
    [
      ./core
      ./hardware
      ./nix
      ./network
      ./programs
      ./services
    ]
    ++ map mylib.relativeToRoot ["secrets"];

  laptop =
    desktop
    ++ [
      ./hardware/bluetooth.nix
      ./services/power.nix
    ];
in {
  inherit desktop laptop;
}
