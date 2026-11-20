{pkgs, ...}: let
  tools = with pkgs; [
    nil
    alejandra
    dotnet-sdk_8
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
  vscodeWithExtensions = pkgs.vscode-with-extensions.override {
    vscodeExtensions = with pkgs.vscode-extensions; [
      ms-dotnettools.csharp
      ms-dotnettools.csdevkit
      ms-dotnettools.vscode-dotnet-runtime
      visualstudiotoolsforunity.vstuc
    ];
  };
  vscodeWithTools = pkgs.symlinkJoin {
    name = "vscode-with-tools";
    paths = [vscodeWithExtensions];
    nativeBuildInputs = [pkgs.makeWrapper];
    postBuild = ''
      wrapProgram $out/bin/code --prefix PATH : ${pkgs.lib.makeBinPath tools}
    '';
  };
in {
  users.users.oxod.packages = [vscodeWithTools];

  xdg.configFile."Code/User/settings.json" = {
    text = builtins.toJSON (import ./settings.nix);
  };

  # Roslyn searches parent directories for EditorConfig. Keeping this in the
  # home directory makes K&R the default for every C# and Unity project.
  home.file.".editorconfig".text = ''
    [*.cs]
    indent_style = space
    indent_size = 4
    csharp_new_line_before_open_brace = none
    csharp_new_line_before_else = false
    csharp_new_line_before_catch = false
    csharp_new_line_before_finally = false
  '';
}
