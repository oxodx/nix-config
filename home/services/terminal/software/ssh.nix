{
  config,
  pkgs,
  secrets,
  ...
}: let
  sshAgentSocket = "${config.xdg.runtimeDir}/ssh-agent.socket";
in {
  users.users.oxod.packages = with pkgs; [openssh];

  home.file.".ssh/git.pub".source = secrets.ssh.git.publicKey;
  home.file.".ssh/homelab-camelot.pub".source = secrets.ssh.camelot.publicKey;
  home.file.".ssh/homelab-excalibur.pub".source = secrets.ssh.excalibur.publicKey;
  home.file.".ssh/homelab-gawain.pub".source = secrets.ssh.gawain.publicKey;

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
      IdentityFile ${secrets.ssh.git.path}

    Host camelot
      HostName 192.168.1.185
      User oxod
      IdentityFile ${secrets.ssh.camelot.path}

    Host excalibur
      HostName 192.168.1.206
      User oxod
      IdentityFile ${secrets.ssh.excalibur.path}

    Host gawain
      HostName 192.168.1.41
      User oxod
      IdentityFile ${secrets.ssh.gawain.path}

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
