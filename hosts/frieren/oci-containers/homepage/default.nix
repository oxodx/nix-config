{
  config,
  pkgs,
  ...
}:
let
  user = "homepage";
  configDir = "/data/apps/homepage-dashboard";
in
{
  users.groups.${user} = { };
  users.users.${user} = {
    group = user;
    home = configDir;
    isSystemUser = true;
  };

  # Install the homepage-dashboard configuration files
  system.activationScripts.installHomepageDashboardConfig = ''
    mkdir -p ${configDir}
    ${pkgs.rsync}/bin/rsync -avz --chmod=D2755,F644 ${./config}/ ${configDir}/
    chown -R ${user}:${user} ${configDir}
  '';

  # Create a custom network with DNS disabled
  systemd.tmpfiles.rules = [
    "d /etc/containers/networks 0755 root root -"
  ];

  environment.etc."containers/networks/homepage-net.json" = {
    text = builtins.toJSON {
      name = "homepage-net";
      dns_enabled = false;
      subnet = "10.89.0.0/24";
      gateway = "10.89.0.1";
    };
  };

  virtualisation.oci-containers.containers = {
    homepage = {
      hostname = "homepage";
      image = "ghcr.io/gethomepage/homepage:latest";
      ports = [ "127.0.0.1:54401:3000" ];
      volumes = [
        "${configDir}:/app/config"
      ];
      autoStart = true;
      extraOptions = [ "--network=homepage-net" ];
    };
  };
}
