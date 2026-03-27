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

  virtualisation.oci-containers.containers = {
    homepage = {
      hostname = "homepage";
      image = "ghcr.io/gethomepage/homepage:latest";
      volumes = [
        "${configDir}:/app/config"
      ];
      autoStart = true;
      network = "host";
      environment = {
        PORT = "54401";
      };
    };
  };
}
