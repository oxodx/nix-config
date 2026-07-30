{ lib, pkgs, config, ... }:
{
  programs.firefox = {
    enable = true;
    configPath = "${config.xdg.configHome}/mozilla/firefox";
    profiles.oxod = { };
  };

  # Uhh firefox fonts are not working without this idk why see https://github.com/NixOS/nixpkgs/issues/546204
  home.sessionVariables.XDG_DATA_DIRS = lib.concatStringsSep ":" [
    "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}"
    "${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}"
  ];
}
