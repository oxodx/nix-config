{
  pkgs,
  ...
}:
{
  imports = [ ./hardware-configuration.nix ];

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
    desktopManager.plasma6.enable = true;
    displayManager.plasma-login-manager.enable = true;

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
    zed-editor
    firefox
    nil
    nixd
  ];

  programs.zsh.enable = true;

  # Uhh firefox fonts are not working without this idk why see https://github.com/NixOS/nixpkgs/issues/546204
  environment.sessionVariables.XDG_DATA_DIRS = [
    "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}"
    "${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}"
  ];

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = [ "gtk" ];
  };

  system.stateVersion = "26.05";
}
