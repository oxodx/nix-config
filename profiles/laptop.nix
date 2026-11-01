{mylib, inputs, ...}: let
  inherit (import (mylib.relativeToRoot "system") {inherit mylib inputs;}) desktop;
in {
  imports = desktop ++ [
    ../system/hardware/bluetooth.nix
    ../system/services/power.nix
  ];
}
