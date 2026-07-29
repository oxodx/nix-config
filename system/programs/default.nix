{ pkgs, ... }:
{
  imports = [
    ./fonts.nix
    ./home-manager.nix
  ];

  programs = {
    dconf.enable = true;
    gpu-screen-recorder.enable = true;
    kdeconnect.enable = true;
  };

  environment.systemPackages = with pkgs; [
    gpu-screen-recorder-gtk
  ];
}
