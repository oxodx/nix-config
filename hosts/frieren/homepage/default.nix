{
  services.homepage-dashboard = {
    enable = true;
    allowedHosts = "home.oxod.nl";

    # https://gethomepage.dev/configs/settings/
    settings = {
      title = "0x0D's Homelab";
      baseUrl = "http://home.oxod.nl";
      startUrl = "http://home.oxod.nl";
      favicon = "https://oxod.nl/favicon.ico";
      useEqualHeights = true;
      headerStyle = "clean";
      theme = "dark";
      color = "slate";
      language = "en";
      layout = {
        "Homelab Monitoring" = {
          icon = "mdi-monitor-dashboard";
          initiallyCollapsed = false;
          tab = "Main";
          style = "row";
          columns = 3;
        };
        "Homelab Applications" = {
          icon = "si-homepage";
          tab = "Main";
        };
      };
      quicklaunch = {
        searchDescriptions = true;
        hideInternetSearch = true;
        showSearchSuggestions = true;
        hideVisitURL = true;
      };
      showStats = true;
      hideErrors = false;
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
