{
  lib,
  pkgs,
  inputs,
  ...
}: let
  pkgs-unstable = import inputs.nixpkgs-unstable {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  };
in {
  imports = [
    ../../profiles/desktop.nix
    ../../system/services/gnomeServices.nix
    ../../system/hardware/cpuAmdPstate.nix
    ../../home
    ./hardware.nix
  ];

  networking.hostName = "tv";

  services = {
    xserver.enable = true;
    desktopManager.plasma6.enable = true;
    displayManager = {
      defaultSession = "plasma-bigscreen-wayland";
      sessionPackages = [pkgs-unstable.kdePackages.plasma-bigscreen];
      sddm = {
        enable = true;
        theme = "breeze";
        wayland.enable = true;
        enableHidpi = true;
        settings = {
          AutoLogin = {
            Session = "plasma.desktop";
            User = "trouble";
          };
        };
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
