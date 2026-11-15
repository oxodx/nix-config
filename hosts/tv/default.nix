{
  lib,
  pkgs,
  mylib,
  inputs,
  ...
}: let
  pkgs-unstable = import inputs.nixpkgs-unstable {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  };
  inherit (import (mylib.relativeToRoot "system") {inherit mylib inputs;}) desktop;
in {
  imports =
    desktop
    ++ [
      (mylib.relativeToRoot "system/services/gnomeServices.nix")
      (mylib.relativeToRoot "system/hardware/cpuAmdPstate.nix")
      (mylib.relativeToRoot "home")
      ./hardware.nix
    ];

  networking.hostName = "tv";

  services = {
    greetd.enable = lib.mkForce false;
    xserver.enable = true;
    desktopManager.plasma6.enable = true;
    displayManager = {
      autoLogin = {
        enable = true;
        user = "trouble";
      };
      defaultSession = "plasma-bigscreen-wayland";
      sessionPackages = [pkgs-unstable.kdePackages.plasma-bigscreen];
      sddm = {
        enable = true;
        theme = "breeze";
        wayland.enable = true;
        enableHidpi = true;
      };
    };
  };

  xdg.portal.configPackages = [pkgs-unstable.kdePackages.plasma-bigscreen];

  users.users.trouble = {
    isNormalUser = true;
    extraGroups = ["networkmanager" "wheel"];
  };

  programs.kdeconnect.enable = true;

  programs.ssh.askPassword = lib.mkForce "${pkgs.seahorse}/libexec/seahorse/ssh-askpass";

  system.stateVersion = "26.05";
}
