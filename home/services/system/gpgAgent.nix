{
  config,
  pkgs,
  ...
}: {
  systemd.user.sockets.gpgAgent = {
    description = "GnuPG cryptographic agent socket";
    wantedBy = ["sockets.target"];
    listenStreams = ["%h/.local/share/gnupg/S.gpg-agent"];
    socketConfig = {
      SocketMode = "0600";
      DirectoryMode = "0700";
      RemoveOnStop = true;
    };
  };

  systemd.user.services.gpgAgent = {
    description = "GnuPG cryptographic agent and passphrase cache";
    documentation = ["man:gpg-agent(1)"];
    wantedBy = ["default.target"];
    requires = ["gpgAgent.socket"];
    after = ["gpgAgent.socket"];

    serviceConfig = {
      Environment = "GNUPGHOME=${config.users.users.oxod.home}/.local/share/gnupg";
      ExecStart = "${pkgs.gnupg}/bin/gpg-agent --supervised";
      ExecReload = "${pkgs.gnupg}/bin/gpgconf --reload gpg-agent";
      Type = "simple";
    };
  };
}
