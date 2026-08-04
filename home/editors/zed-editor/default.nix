{pkgs, ...}: let
  mySettings = import ./settings.nix;
  myLsp = import ./lsp.nix;

  # https://github.com/yuja/tree-sitter-qmljs
  qmljsGrammar = pkgs.buildZedGrammar (finalAttrs: {
    name = "qmljs";
    version = "febf48a5b6928600cd8fb2a01254743af550780d";
    src = pkgs.fetchFromGitHub {
      owner = "yuja";
      repo = "tree-sitter-qmljs";
      hash = "sha256-bRb5h6gBBxbzhxpCxJK8CsQ5BCtPTuKtuZesE/+mDY0=";
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
      // {
        lsp = myLsp;
      };
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
