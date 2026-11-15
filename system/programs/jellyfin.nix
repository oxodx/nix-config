{
  pkgs,
  self,
  mylib,
  ...
}: {
  environment.systemPackages = [
    (self.lib.mkWebApp pkgs {
      name = "jellyfin";
      title = "Jellyfin";
      url = "https://jellyfin.oxod.home/";
      icon = mylib.relativeToRoot "assets/jellyfin.png";
    })
  ];
}
