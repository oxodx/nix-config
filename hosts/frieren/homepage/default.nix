{
  services.homepage-dashboard = {
    enable = true;

    # https://gethomepage.dev/configs/settings/
    settings = {
      title = "0x0D's Homelab";
      baseUrl = "http://home.oxod.nl";
      startUrl = "http://home.oxod.nl";
      favicon = "https://oxod.nl/favicon.ico";
      headerStyle = "clean";
      theme = "dark";
      color = "slate";
      language = "en";
    };

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
