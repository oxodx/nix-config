{
  config,
  pkgs,
  ...
}: let
  sshAgentSocket = "${config.xdg.runtimeDir}/ssh-agent.socket";
in {
  users.users.oxod.packages = with pkgs; [
    openssh
  ];

  home.file.".ssh/config".text = ''
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

    Host github.com
      HostName github.com
      User git
      IdentityFile ~/.ssh/git

    Include ~/.ssh/config.d/*
  '';

  environment.sessionVariables = {
    SSH_AUTH_SOCK = sshAgentSocket;
  };

  systemd.user.services.ssh-agent = {
    description = "SSH agent service";
    wantedBy = ["default.target"];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.openssh}/bin/ssh-agent -D -a ${sshAgentSocket}";
      Restart = "on-failure";
    };
  };
}
