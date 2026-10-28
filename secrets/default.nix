{
  config,
  lib,
  ...
}: let
  username = "oxod";
  sshDirectory = "${config.users.users.${username}.home}/.ssh";
  hostName = config.networking.hostName;

  # Each identity declares its encrypted source, destination and consumers.
  identities = {
    git = {
      secretName = "git-ssh-key";
      fileName = "git";
      clients = ["laptop" "tv"];
      server = null;
    };
    camelot = {
      secretName = "homelab-camelot";
      fileName = "homelab-camelot";
      clients = ["laptop"];
      server = "camelot-nixos";
    };
    excalibur = {
      secretName = "homelab-excalibur";
      fileName = "homelab-excalibur";
      clients = ["laptop"];
      server = "excalibur-nixos";
    };
    gawain = {
      secretName = "homelab-gawain";
      fileName = "homelab-gawain";
      clients = ["laptop"];
      server = "gawain-nixos";
    };
  };

  secrets.ssh =
    lib.mapAttrs (name: identity: {
      path = "${sshDirectory}/${identity.fileName}";
      publicKey = ./. + "/${name}.pub";
    })
    identities;
in {
  # Consumers accept {secrets, ...} and use secrets.ssh.<name>.path.
  _module.args = {inherit secrets;};

  age.secrets = lib.mapAttrs' (name: identity:
    lib.nameValuePair identity.secretName {
      file = ./. + "/${name}.age";
      path = secrets.ssh.${name}.path;
      owner = username;
      group = "users";
      mode = "0600";
    })
  (lib.filterAttrs (_: identity: builtins.elem hostName identity.clients) identities);

  users.users.${username}.openssh.authorizedKeys.keyFiles =
    lib.mapAttrsToList (name: _: secrets.ssh.${name}.publicKey)
    (lib.filterAttrs (_: identity: identity.server == hostName) identities);
}
