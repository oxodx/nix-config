let
  desktop = [
    ./core
    ./hardware
    ./nix
    ./network
    ./programs
    ./services
  ];

  laptop = desktop ++ [
    ./hardware/bluetooth.nix
    ./services/power.nix
  ];
in
{
  inherit desktop laptop;
}
