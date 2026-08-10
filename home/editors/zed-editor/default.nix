{pkgs, ...}: let
  mySettings = import ./settings.nix;
  myAgent = import ./agent.nix;
  myLsp = import ./lsp.nix;

  # https://github.com/yuja/tree-sitter-qmljs
  qmljsGrammar = pkgs.buildZedGrammar (finalAttrs: {
    name = "qmljs";
    version = "de96ed62abded51fcdfcbeaaa120e0dd0d20c697";
    src = pkgs.fetchFromGitHub {
      owner = "yuja";
      repo = "tree-sitter-qmljs";
      hash = "sha256-Yn3/adOETfPHBVCIVfI5qXUwC2wQr14pbhK2aUtdCiY=";
      rev = finalAttrs.version;
    };
  });

  # https://github.com/lkroll/zed-qml
  zedQml = pkgs.buildZedRustExtension (finalAttrs: {
    name = "zed-qml";
    version = "1c5badf066af33234c589fbc627029074c0a6699";
    src = pkgs.fetchFromGitHub {
      owner = "lkroll";
      repo = "zed-qml";
      hash = "sha256-Ggz0h69pYV8LhnyfIu035bEFmLNRCH89YdsvqgHBB9I=";
      rev = finalAttrs.version;
    };
    cargoHash = "sha256-EtYYXMnJEogl0Q1KPyQk2m59qnzNZuRNo32/NFkDBL0=";
    grammars = [qmljsGrammar];
  });
in {
  programs.zed-editor = {
    enable = true;

    extraPackages = with pkgs; [
      nixd
      qt6.qtdeclarative
    ];

    userSettings =
      mySettings
      // myAgent
      // {lsp = myLsp {inherit pkgs;};};
  };

  programs.zed-editor-extensions = {
    enable = true;
    packages = with pkgs.zed-extensions;
      [
        tokyo-night
        catppuccin-icons
        toml
      ]
      ++ [zedQml];
  };

  home.packages = with pkgs; [
    vtsls
  ];
}
