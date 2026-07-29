let
  desktop = [
    ./core
    ./hardware
    ./nix
    ./network
    ./programs
  ];

  laptop = desktop ++ [

  ];
in
{
  inherit desktop laptop;
}
