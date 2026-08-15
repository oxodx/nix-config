{mylib, ...}: {
  imports = mylib.scanPaths ./.;

  environment.variables.NH_FLAKE = "/home/oxod/dev/dotfiles";

  networking.hostName = "homelab-01";

  programs.ssh.extraConfig = ''
    Host github.com
      User git
      Hostname github.com
      PreferredAuthentications publickey
      IdentityFile /home/oxod/.ssh/github
  '';

  networking.networkmanager.enable = true;

  security.tpm2.enable = true;

  system.stateVersion = "26.05";
}
