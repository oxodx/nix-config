{pkgs, ...}: let
  myExtensions = import ./extensions.nix;
  mySettings = import ./settings.nix;
  myLsp = import ./lsp.nix;
in {
  programs.zed-editor = {
    enable = true;

    extraPackages = with pkgs; [
      nixd
    ];

    extensions = myExtensions;
    userSettings =
      mySettings
      // {
        lsp = myLsp;
      };
  };
}
