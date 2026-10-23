{
  lib,
  pkgs,
  ...
}: let
  ardour = pkgs.ardour;
  majorVersion = lib.versions.major ardour.version;
  libraries = pkgs.runCommand "ardour-pipewire-libraries" {} ''
    mkdir -p "$out"
    for entry in ${ardour}/lib/ardour${majorVersion}/*; do
      case "$entry" in */backends) continue ;; esac
      ln -s "$entry" "$out/"
    done
    mkdir -p "$out/backends"
    ln -s ${ardour}/lib/ardour${majorVersion}/backends/libjack_audiobackend.so "$out/backends/"
  '';
  desktopArdour = pkgs.symlinkJoin {
    name = "ardour-pipewire-${ardour.version}";
    paths = [ardour];
    nativeBuildInputs = [pkgs.makeWrapper];
    postBuild = ''
      # Replace the symlink, not the upstream file. Its startup script resets
      # ARDOUR_DLL_PATH and would expose the direct ALSA backend again.
      unlink "$out/bin/ardour${majorVersion}"
      makeWrapper ${ardour}/lib/ardour${majorVersion}/ardour-[0-9]* "$out/bin/ardour${majorVersion}" \
        --set ARDOUR_DLL_PATH ${libraries} \
        --set ARDOUR_DATA_PATH ${ardour}/share/ardour${majorVersion} \
        --set ARDOUR_CONFIG_PATH ${ardour}/etc/ardour${majorVersion} \
        --set ARDOUR_SELF ardour${majorVersion} \
        --set UBUNTU_MENUPROXY "" \
        --prefix GTK_PATH : ${ardour}/etc/ardour${majorVersion}:${libraries} \
        --prefix VAMP_PATH : ${libraries}/vamp \
        --prefix PATH : ${lib.makeBinPath [pkgs.harvid pkgs.xjadeo]} \
        --prefix LD_LIBRARY_PATH : ${libraries}:${pkgs.pipewire.jack}/lib
    '';
  };
in {
  users.users.oxod.packages = [desktopArdour];
}
