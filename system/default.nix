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

  ];
in
{
  inherit desktop laptop;
}
