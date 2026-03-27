{
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
}
