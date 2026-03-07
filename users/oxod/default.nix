{ config, lib, pkgs, inputs, self, ... }: {
  imports = [
    ./shells/default.nix
  ];

  programs.home-manager.enable = true;

  home.username = "oxod";
  home.homeDirectory = "/home/oxod";

  home.packages = with pkgs; [
    discord
    lutris
    osu-lazer
    mesa-demos
    vulkan-tools
    nixpkgs-fmt
    unar
    p7zip
  ];

  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "0x0D";
        email = "0xOD@proton.me";
      };

      checkout.defaultRemote = "origin";
      core.eol = "lf";
      diff.colorMoved = "zebra";
      fetch.prune = true;
      init.defaultBranch = "main";
      rebase.autostash = true;
      pull.rebase = true;
      merge.tool = "vscode";
      diff.tool = "vscode";
      mergeTool = {
        keepBackup = false;
        vscode.cmd = "code --wait --new-window $MERGED";
      };
      difftool.vscode.cmd = "code --wait --new-window --diff $LOCAL $REMOTE";
    };
  };

  programs.firefox.enable = true;
  programs.vscode.enable = true;
  programs.nix-index.enable = true;

  home.stateVersion = "25.11";
}
