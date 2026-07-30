{
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./hyprland.nix
  ];

  environment.variables.NH_FLAKE = "/home/oxod/dev/dotfiles";

  networking.hostName = "laptop";

  programs.ssh.extraConfig = ''
    Host github.com
      User git
      Hostname github.com
      PreferredAuthentications publickey
      IdentityFile /home/oxod/.ssh/github
  '';

  networking.networkmanager.enable = true;

  security.tpm2.enable = true;

  services = {
    xserver = {
      enable = true;
      xkb.layout = "us";
    };

    pipewire = {
      enable = true;
      pulse.enable = true;
    };

    fstrim.enable = true;
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  environment.systemPackages = with pkgs; [
    neovim
    wget
    nil
    nixd
  ];

  programs.zsh.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = [ "gtk" ];
  };

  system.stateVersion = "26.05";
}
