{mylib, inputs, ...}: let
  inherit (import (mylib.relativeToRoot "system") {inherit mylib inputs;}) base;
in {
  imports = base ++ [
    ../system/programs/fish.nix
  ];
}
