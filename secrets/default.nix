{
  config,
  lib,
  ...
}: let
  sshGitPath = "${config.users.users.oxod.home}/.ssh/git";

  secrets = {
    ssh = {
      git = {
        path = sshGitPath;
        publicKey = ./git.pub;
      };
      camelot = {
        path = "${config.users.users.oxod.home}/.ssh/homelab-camelot";
        publicKey = ./camelot.pub;
      };
      excalibur = {
        path = "${config.users.users.oxod.home}/.ssh/homelab-excalibur";
        publicKey = ./excalibur.pub;
      };
      gawain = {
        path = "${config.users.users.oxod.home}/.ssh/homelab-gawain";
        publicKey = ./gawain.pub;
      };
    };
  };
in {
  # Expose the registry to every module as the `secrets` argument.
  _module.args = {inherit secrets;};

  age.secrets.git-ssh-key = lib.mkIf (builtins.elem config.networking.hostName ["laptop" "tv"]) {
    file = ./git.age;
    path = sshGitPath;
    owner = "oxod";
    group = "users";
    mode = "0600";
  };

  age.secrets.homelab-camelot = lib.mkIf (config.networking.hostName == "laptop") {
    file = ./camelot.age;
    path = secrets.ssh.camelot.path;
    owner = "oxod";
    group = "users";
    mode = "0600";
  };

  age.secrets.homelab-excalibur = lib.mkIf (config.networking.hostName == "laptop") {
    file = ./excalibur.age;
    path = secrets.ssh.excalibur.path;
    owner = "oxod";
    group = "users";
    mode = "0600";
  };

  age.secrets.homelab-gawain = lib.mkIf (config.networking.hostName == "laptop") {
    file = ./gawain.age;
    path = secrets.ssh.gawain.path;
    owner = "oxod";
    group = "users";
    mode = "0600";
  };

  users.users.oxod.openssh.authorizedKeys.keyFiles =
    lib.optionals (config.networking.hostName == "camelot-nixos") [secrets.ssh.camelot.publicKey]
    ++ lib.optionals (config.networking.hostName == "excalibur-nixos") [secrets.ssh.excalibur.publicKey]
    ++ lib.optionals (config.networking.hostName == "gawain-nixos") [secrets.ssh.gawain.publicKey];
}
