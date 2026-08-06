{inputs, ...}: {
  imports = [
    ./terminal
    inputs.matugen.nixosModules.default
    inputs.nix-index-db.homeModules.nix-index
    inputs.zed-extensions.homeManagerModules.default
  ];

  home = {
    username = "oxod";
    homeDirectory = "/home/oxod";
    stateVersion = "26.05";
    extraOutputsToInstall = [
      "doc"
      "devdoc"
    ];
  };

  # disable manuals as nmd fails to build often
  manual = {
    html.enable = false;
    json.enable = false;
    manpages.enable = false;
  };

  # let HM manage itself when in standalone mode
  programs.home-manager.enable = true;
}
