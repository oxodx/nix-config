{
  config,
  pkgs,
  ...
}: {
  systemd.user.services.gpgAgent = {
    description = "GnuPG cryptographic agent and passphrase cache";
    documentation = ["man:gpg-agent(1)"];
    wantedBy = ["default.target"];

    serviceConfig = {
      Environment = "GNUPGHOME=${config.users.users.oxod.home}/.local/share/gnupg";
      ExecStart = "${pkgs.gnupg}/bin/gpg-agent --supervised";
      ExecReload = "${pkgs.gnupg}/bin/gpgconf --reload gpg-agent";
      Type = "simple";
    };
  };
}
