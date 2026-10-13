{
  config,
  pkgs,
  ...
}: let
  sshConfigFile = "ssh/config";
in {
  users.users.oxod.packages = with pkgs; [
    openssh
  ];

  xdg.configFile."${sshConfigFile}".text = ''
    AddKeysToAgent yes
    CheckHostIP yes
    Compression no
    ControlMaster no
    ControlPath ~/.ssh/master-%r@%n:%p
    ControlPersist no
    HashKnownHosts yes
    IdentitiesOnly yes
    PasswordAuthentication no
    ForwardAgent no
    ForwardX11 no
    ForwardX11Trusted no
    ServerAliveInterval 60
    ServerAliveCountMax 3
    UserKnownHostsFile ~/.ssh/known_hosts

    Include ~/.ssh/config.d/*
  '';

  environment.sessionVariables = {
    SSH_AUTH_SOCK = "${config.xdg.runtimeDir}/gnupg/S.gpg-agent.ssh";
  };

  systemd.user.services.ssh-agent = {
    description = "SSH agent service";
    wantedBy = ["default.target"];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.openssh}/bin/ssh-agent -D -a ${config.xdg.runtimeDir}/ssh-agent.socket";
      Restart = "on-failure";
    };
  };
}
