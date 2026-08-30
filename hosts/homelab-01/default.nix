{ mylib, ... }: {
  imports = mylib.scanPaths ./.;

  environment.variables.NH_FLAKE = "/home/oxod/dev/nix-config";

  networking.hostName = "homelab-01";

  programs.ssh.extraConfig = ''
    Host github.com
      User git
      Hostname github.com
      PreferredAuthentications publickey
      IdentityFile /home/oxod/.ssh/github
  '';

  networking.networkmanager.enable = true;

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  users.users.oxod.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG7W3t1Iqy/s2ztBP+f24+QvuASSpCIZfUvAtc4tc2BE oxod@laptop"
  ];

  security.tpm2.enable = true;

  system.activationScripts.fix-private-permissions = ''
    chmod 751 /var/lib/private
  '';

  system.stateVersion = "26.05";
}
