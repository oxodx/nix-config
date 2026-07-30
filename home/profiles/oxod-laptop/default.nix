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

    "${home}/services/quickshell"
    "${home}/services/media/playerctl.nix"
    "${home}/services/system/kdeconnect.nix"
    "${home}/services/system/polkit-agent.nix"
    "${home}/services/system/syncthing.nix"
    "${home}/services/system/theme.nix"
    "${home}/services/system/udiskie.nix"

    "${home}/terminal/emulators/alacritty.nix"
  ];
}
