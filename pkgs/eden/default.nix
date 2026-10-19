{
  lib,
  eden,
  bubblewrap,
  coreutils,
  findutils,
  writeShellApplication,
  makeDesktopItem,
  symlinkJoin,
}: let
  launcher = writeShellApplication {
    name = "eden";
    runtimeInputs = [coreutils findutils];
    text = ''
      EDEN_BINARY=${lib.getExe eden}
      BWRAP_BINARY=${lib.getExe bubblewrap}
      ${builtins.readFile ./eden.sh}
    '';
  };
  desktop = makeDesktopItem {
    name = "eden-sandbox";
    desktopName = "Eden";
    genericName = "Nintendo Switch Emulator";
    comment = "Launch Eden in an offline Bubblewrap sandbox";
    exec = "eden";
    icon = "dev.eden_emu.eden";
    categories = ["Game" "Emulator"];
  };
in
  symlinkJoin {
    name = "eden-sandbox-${eden.version}";
    paths = [launcher desktop];
    postBuild = ''
      if [ -d ${eden}/share/icons ]; then
        ln -s ${eden}/share/icons "$out/share/icons"
      fi
    '';
    meta = {
      description = "Eden Nintendo Switch emulator with an offline sandbox";
      inherit (eden.meta) license platforms;
      mainProgram = "eden";
    };
  }
