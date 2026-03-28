{
  users.groups.docker = { };

  services.homepage-dashboard = {
    enable = true;
    allowedHosts = "home.oxod.nl";

    settings = import ./settings.nix; # https://gethomepage.dev/configs/settings/
    bookmarks = import ./bookmarks.nix; # https://gethomepage.dev/configs/bookmarks/
    services = import ./services.nix; # https://gethomepage.dev/configs/services/
    widgets = [
      {
        search = {
          provider = "duckduckgo";
          target = "_blank";
        };
      }
    ]; # https://gethomepage.dev/configs/service-widgets/
    kubernetes = {
      mode = "disabled";
    }; # https://gethomepage.dev/configs/kubernetes/
    docker = {
      mode = "disabled";
    }; # https://gethomepage.dev/configs/docker/

    # https://gethomepage.dev/configs/custom-css-js/
    customJS = "";
    customCSS = "";
  };

  systemd.services.homepage-dashboard = {
    serviceConfig = {
      SupplementaryGroups = [ "docker" ];
    };
  };
}
