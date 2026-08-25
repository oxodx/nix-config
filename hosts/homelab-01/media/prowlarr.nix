{
  pkgs,
  lib,
  ...
}: let
  vars = import ./_variables.nix;
  vUser = vars.services.prowlarr.user;
  vGroup = vars.services.prowlarr.group;

  enable = true;
  package = pkgs.prowlarr;
  stateDir = "${vars.dirs.state}/prowlarr";
  openFirewall = true;
  port = 9696;
in {
  systemd.tmpfiles.rules = [
    "d '${stateDir}' 0700 ${vUser} root - -"
  ];

  services.prowlarr = {
    inherit
      enable
      package
      ;

    openFirewall = openFirewall && !vars.vpn.enable;

    settings.server.port = port;
    dataDir = stateDir;
  };

  systemd.services.prowlarr.serviceConfig = {
    User = vUser;
    Group = vGroup;
    ReadWritePaths = [stateDir];
    IOSchedulingPriority = 7;
  };

  systemd.services.prowlarr.vpnConfinement = lib.mkIf vars.vpn.enable {
    enable = true;
    vpnNamespace = "wg";
  };

  vpnNamespaces.wg = lib.mkIf vars.vpn.enable {
    portMappings = [
      {
        from = port;
        to = port;
      }
    ];
  };

  users = {
    groups.${vGroup}.gid = vars.gids.${vGroup};
    users.${vUser} = {
      isSystemUser = true;
      group = vGroup;
      uid = vars.uids.${vUser};
    };
  };

  networking.firewall = lib.mkIf (openFirewall && !vars.vpn.enable) {
    allowedTCPPorts = [port];
  };
}
