{ self, ... }:
let
  home = "${self}/home";
in
{
  imports = [
    "${home}/editors/zed.nix"

    "${home}/programs"
    "${home}/programs/wayland"
    "${home}/programs/browsers/firefox.nix"

    "${home}/terminal/emulators/alacritty.nix"
  ];
}
