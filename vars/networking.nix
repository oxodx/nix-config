{ lib }:
rec {
  mainGateway = "192.168.1.1";
  nameservers = [
    # IPv4
    "8.8.8.8"
    "4.4.4.4"
  ];
  prefixLength = 24;

  hostAddr = {
    homelab = {
      iface = "enp2s0";
      ipv4 = "192.168.1.191";
    };
  };

  hostsInterface = lib.attrsets.mapAttrs (key: val: {
    interfaces."${val.iface}" = {
      useDHCP = false;
      ipv4.addresses = [
        {
          inherit prefixLength;
          address = val.ipv4;
        }
      ];
    };
  }) hostsAddr;

  ssh = {
    # define the host alias for remote builders
    # this config will be written to /etc/ssh/ssh_config
    #
    # Config format:
    #   Host —  given the pattern used to match against the host name given on the command line.
    #   HostName — specify nickname or abbreviation for host
    #   IdentityFile — the location of your SSH key authentication file for the account.
    # Format in details:
    #   https://www.ssh.com/academy/ssh/config
    extraConfig = (
      lib.attrsets.foldlAttrs (
        acc: host: val:
        acc
        + ''
          Host ${host}
            HostName ${val.ipv4}
            Port 22
        ''
      ) "" hostsAddr
    );

    # this config will be written to /etc/ssh/ssh_known_hosts
    knownHosts =
      # Update only the values of the given attribute set.
      #
      #   mapAttrs
      #   (name: value: ("bar-" + value))
      #   { x = "a"; y = "b"; }
      #     => { x = "bar-a"; y = "bar-b"; }
      lib.attrsets.mapAttrs
        (host: value: {
          hostNames = [ host ] ++ (lib.optional (hostsAddr ? host) hostsAddr.${host}.ipv4);
          publicKey = value.publicKey;
        })
        {
          homelab.publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILUGA8ozQcDCxa3TvTLHmpinCmh6ZKZkM7MUSxBHPRM0 oxod@homelab";

          # ==================================== Other SSH Service's Public Key =======================================

          # https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/githubs-ssh-key-fingerprints
          "github.com".publicKey =
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFq1eYW8+3zOgM1/8JofUiAlimyEBjSVLerE46pYQBTK oxod@romantic";
        };
  };
}
