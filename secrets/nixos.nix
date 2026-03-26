{
  lib,
  config,
  pkgs,
  agenix,
  mysecrets,
  myvars,
  ...
}:
with lib;
let
  cfg = config.modules.secrets;

  enabledServerSecrets = cfg.server.application.enable || cfg.server.operation.enable;

  noaccess = {
    mode = "0000";
    owner = "root";
  };
  high_security = {
    mode = "0500";
    owner = "root";
  };
  user_readable = {
    mode = "0500";
    owner = myvars.username;
  };
in
{
  imports = [
    agenix.nixosModules.default
  ];

  options.modules.secrets = {
    desktop.enable = mkEnableOption "NixOS Secrets for Desktops";

    server.application.enable = mkEnableOption "NixOS Secrets for Application Servers";
    server.operation.enable = mkEnableOption "NixOS Secrets for Operation Servers(Backup, Monitoring, etc)";
  };

  config = mkIf (cfg.desktop.enable || enabledServerSecrets) (mkMerge [
    {
      environment.systemPackages = [
        agenix.packages."${pkgs.stdenv.hostPlatform.system}".default
      ];

      # if you changed this key, you need to regenerate all encrypt files from the decrypt contents!
      age.identityPaths = [
        "/etc/ssh/ssh_host_ed25519_key"
      ];

      assertions = [
        {
          # This expression should be true to pass the assertion
          assertion = !(cfg.desktop.enable && enabledServerSecrets);
          message = "Enable either desktop or server's secrets, not both!";
        }
      ];
    }

    (mkIf cfg.desktop.enable {
      age.secrets = {
        # ---------------------------------------------
        # no one can read/write this file, even root.
        # ---------------------------------------------

        # .age means the decrypted file is still encrypted by age(via a passphrase)
        "oxod-gpg-subkeys.priv.age" = {
          file = "${mysecrets}/oxod-gpg-subkeys-2024-01-27.priv.age.age";
        }
        // noaccess;

        # ---------------------------------------------
        # user can read this file.
        # ---------------------------------------------

        "ssh-key-romantic" = {
          file = "${mysecrets}/ssh-key-romantic.age";
        }
        // user_readable;
        "ssh-key-kumquat" = {
          file = "${mysecrets}/ssh-key-kumquat.age";
        }
        // user_readable;
        "ssh-key-homelab" = {
          file = "${mysecrets}/ssh-key-homelab.age";
        }
        // user_readable;
      };

      # place secrets in /etc/
      environment.etc = {
        "agenix/ssh-key-romantic" = {
          source = config.age.secrets."ssh-key-romantic".path;
          mode = "0600";
          user = myvars.username;
        };
        "agenix/ssh-key-kumquat" = {
          source = config.age.secrets."ssh-key-kumquat".path;
          mode = "0600";
          user = myvars.username;
        };
        "agenix/ssh-key-homelab" = {
          source = config.age.secrets."ssh-key-homelab".path;
          mode = "0600";
          user = myvars.username;
        };

        "agenix/oxod-gpg-subkeys.priv.age" = {
          source = config.age.secrets."oxod-gpg-subkeys.priv.age".path;
          mode = "0000";
        };
      };
    })

    (mkIf cfg.server.application.enable {
      age.secrets = {
        # "transmission-credentials.json" = {
        #   file = "${mysecrets}/server/transmission-credentials.json.age";
        # }
        # // high_security;

        # "sftpgo.env" = {
        #   file = "${mysecrets}/server/sftpgo.env.age";
        #   mode = "0400";
        #   owner = "sftpgo";
        # };
        # "minio.env" = {
        #   file = "${mysecrets}/server/minio.env.age";
        #   mode = "0400";
        #   owner = "minio";
        # };
      };
    })

    (mkIf cfg.server.operation.enable {
      age.secrets."cloudflare-creds" = {
        file = "${mysecrets}/cloudflare-creds.json.age";
        mode = "0400";
        owner = "root";
      };
    })
  ]);
}
