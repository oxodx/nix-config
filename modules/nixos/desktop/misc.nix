{ lib, pkgs, ... }:
{
  boot.loader.timeout = lib.mkForce 10;

  environment.shells = with pkgs; [
    bashInteractive
    nushell
  ];
  users.defaultUserShell = pkgs.bashInteractive;

  security.sudo.keepTerminfo = true;

  environment.systemPackages = with pkgs; [
    gnumake
    wl-clipboard
  ];

  services = {
    gvfs.enable = true;
    tumbler.enable = true;
  };

  programs = {
    dconf.enable = true;

    thunar = {
      enable = true;
      plugins = with pkgs; [
        thunar-archive-plugin
        thunar-volman
      ];
    };
  };
}
