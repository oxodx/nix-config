{pkgs, ...}: let
  direnvConfigFile = "direnv/direnv.toml";
  direnvRcFile = "direnv/direnvrc";
in {
  users.users.oxod.packages = with pkgs; [
    alejandra
    deadnix
    statix
    direnv
    nix-direnv
  ];

  xdg = {
    configFile = {
      "${direnvConfigFile}".source = (pkgs.formats.toml {}).generate "direnv.toml" {
        global = {
          log_format = "-";
          log_filter = "^$";
        };
      };
      "${direnvRcFile}".text = ''
        source ${pkgs.nix-direnv}/share/nix-direnv/direnvrc
      '';

      "fish/conf.d/direnv.fish".source = pkgs.runCommand "direnv-fish-hook" {} ''
        ${pkgs.direnv}/bin/direnv hook fish > $out
      '';
    };
  };

  environment.sessionVariables = {
    DIRENV_LOG_FORMAT = "";
  };
}
