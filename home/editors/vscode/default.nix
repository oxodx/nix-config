{pkgs, ...}: let
  tools = with pkgs; [
    nil
    alejandra
    nodejs
    python3
    python3Packages.yapf
    rustc
    cargo
    rustfmt
    clippy
    gcc
    kdePackages.qtdeclarative
  ];
  vscodeWithTools = pkgs.symlinkJoin {
    name = "vscode-with-tools";
    paths = [pkgs.vscode];
    nativeBuildInputs = [pkgs.makeWrapper];
    postBuild = ''
      wrapProgram $out/bin/code --prefix PATH : ${pkgs.lib.makeBinPath tools}
    '';
  };
in {
  users.users.oxod.packages = [vscodeWithTools];

  xdg.configFile."Code/User/settings.json" = {
    text = builtins.toJSON (import ./settings.nix);
    mutable = true;
  };
}
