{
  services.homepage-dashboard = {
    enable = true;
    allowedHosts = "home.oxod.nl";

    # https://gethomepage.dev/configs/settings/
    settings = import ./settings.nix;

    # https://gethomepage.dev/configs/bookmarks/
    bookmarks = [ ];

    # https://gethomepage.dev/configs/services/
    services = [ ];

    # https://gethomepage.dev/configs/service-widgets/
    widgets = [ ];

    # https://gethomepage.dev/configs/kubernetes/
    kubernetes = { };

    # https://gethomepage.dev/configs/docker/
    docker = { };

    # https://gethomepage.dev/configs/custom-css-js/
    customJS = "";
    customCSS = "";
  };
}
