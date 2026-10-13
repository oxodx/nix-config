{pkgs, ...}: let
  configFile = "bottom/bottom.toml";
  toTOML = (pkgs.formats.toml {}).generate;

  btopAlias = pkgs.symlinkJoin {
    name = "btop";
    paths = [pkgs.bottom];
    buildInputs = [pkgs.makeWrapper];
    postBuild = ''
      rm $out/bin/btop 2>/dev/null || true
      makeWrapper ${pkgs.bottom}/bin/btm $out/bin/btop
    '';
  };

  htopAlias = pkgs.symlinkJoin {
    name = "htop";
    paths = [pkgs.bottom];
    buildInputs = [pkgs.makeWrapper];
    postBuild = ''
      rm $out/bin/htop 2>/dev/null || true
      makeWrapper ${pkgs.bottom}/bin/btm $out/bin/htop \
        --add-flags "-b"
    '';
  };
in {
  users.users.oxod.packages = with pkgs; [
    bottom
    btopAlias
    htopAlias
  ];

  xdg.configFile."${configFile}".source = toTOML "bottom.toml" {
    enable_gpu = true;
    flags.group_processes = true;
    row = [
      {
        ratio = 2;
        child = [
          {type = "cpu";}
          {type = "mem";}
        ];
      }
      {
        ratio = 3;
        child = [
          {
            type = "proc";
            ratio = 1;
            default = true;
          }
        ];
      }
    ];
  };
}
