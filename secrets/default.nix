{
  config,
  lib,
  ...
}: let
  sshGitPath = "${config.users.users.oxod.home}/.ssh/git";

  secrets = {
    ssh.git = {
      path = sshGitPath;
      publicKey = ./git.pub;
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
}
