{
  self,
  mylib,
  pkgs,
  ...
}: {
  imports = [
    ./fish.nix
    ./fonts.nix
    ./qt.nix
    ./xdg.nix
  ];

  programs = {
    dconf.enable = true;
    nix-ld.enable = true;
    seahorse.enable = true;
  };

  environment.systemPackages = [
    (let
      name = "jellyfin";
      url = "https://jellyfin.oxod.home/";
    in
      self.lib.mkWebApp pkgs {
        inherit
          name
          url
          ;
        icon = mylib.relativeToRoot "assets/jellyfin.png";
      })
  ];
}
