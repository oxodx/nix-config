{
  services.homepage-dashboard = {
    enable = true;
    allowedHosts = "home.oxod.nl";

    settings = import ./settings.nix; # https://gethomepage.dev/configs/settings/
    bookmarks = import ./bookmarks.nix; # https://gethomepage.dev/configs/bookmarks/
    services = [ ]; # https://gethomepage.dev/configs/services/
    widgets = [ ]; # https://gethomepage.dev/configs/service-widgets/
    kubernetes = { }; # https://gethomepage.dev/configs/kubernetes/
    docker = { }; # https://gethomepage.dev/configs/docker/

    # https://gethomepage.dev/configs/custom-css-js/
    customJS = "";
    customCSS = "";
  };
}
