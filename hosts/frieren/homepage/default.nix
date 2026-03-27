{
  services.homepage-dashboard = {
    enable = true;

    # https://gethomepage.dev/latest/configs/settings/
    settings = {
      title = "0x0D's Homelab";
      favicon = "https://oxod.nl/favicon.ico";
      headerStyle = "clean";
    };

    # https://gethomepage.dev/latest/configs/bookmarks/
    bookmarks = [ ];

    # https://gethomepage.dev/latest/configs/services/
    services = [ ];

    # https://gethomepage.dev/latest/configs/service-widgets/
    widgets = [ ];

    # https://gethomepage.dev/latest/configs/kubernetes/
    kubernetes = { };

    # https://gethomepage.dev/latest/configs/docker/
    docker = { };

    # https://gethomepage.dev/latest/configs/custom-css-js/
    customJS = "";
    customCSS = "";
  };
}
