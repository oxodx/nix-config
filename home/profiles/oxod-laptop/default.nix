{ self, ... }:
let
  home = "${self}/home";
in
{
  imports = [
    "${home}/editors/zed.nix"

    "${home}/terminal/emulators/alacritty.nix"
  ];
}
