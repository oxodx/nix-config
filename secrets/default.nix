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

  secrets.magister = {
    keystore.path = "${config.users.users.${username}.home}/.config/magister-secrets/android-release.keystore";
    githubActions.path = "${config.users.users.${username}.home}/.config/magister-secrets/github-actions.env";
  };
in {
  # Consumers accept {secrets, ...} and use secrets.ssh.<name>.path.
  _module.args = {inherit secrets;};

  age.secrets =
    lib.mapAttrs' (name: identity:
      lib.nameValuePair identity.secretName {
        file = ./. + "/${name}.age";
        path = secrets.ssh.${name}.path;
        owner = username;
        group = "users";
        mode = "0600";
      })
    (lib.filterAttrs (_: identity: builtins.elem hostName identity.clients) identities)
    // lib.optionalAttrs (hostName == "oxod-laptop") {
      magister-android-keystore = {
        file = ./magister-android-keystore.age;
        path = secrets.magister.keystore.path;
        owner = username;
        group = "users";
        mode = "0600";
      };
      magister-github-actions = {
        file = ./magister-github-actions.age;
        path = secrets.magister.githubActions.path;
        owner = username;
        group = "users";
        mode = "0600";
      };
    };

  users.users.${username}.openssh.authorizedKeys.keyFiles =
    lib.mapAttrsToList (name: _: secrets.ssh.${name}.publicKey)
    (lib.filterAttrs (_: identity: identity.server == hostName) identities);
}
