{
  pkgs,
  lib,
  ...
}: let
  browser = ["firefox.desktop"];
  imageViewer = ["org.gnome.Loupe.desktop"];
  videoPlayer = ["io.github.celluloid_player.Celluloid.desktop"];
  audioPlayer = ["io.bassi.Amberol.desktop"];

  xdgAssociations = type: program: list:
    builtins.listToAttrs (map (e: {
        name = "${type}/${e}";
        value = program;
      })
      list);

  image = xdgAssociations "image" imageViewer ["png" "jpg" "jpeg" "gif" "webp" "bmp" "tiff" "tif" "ico" "svg" "avif" "heic" "heif"];
  video = xdgAssociations "video" videoPlayer ["mp4" "avi" "mkv" "mov" "wmv" "flv" "webm" "m4v" "3gp" "ogv" "ts" "mts" "m2ts"];
  audio = xdgAssociations "audio" audioPlayer ["mp3" "flac" "wav" "aac" "ogg" "oga" "opus" "m4a" "wma" "ape" "alac" "aiff"];

  browserTypes =
    (xdgAssociations "application" browser ["json" "x-extension-htm" "x-extension-html" "x-extension-shtml" "x-extension-xht" "x-extension-xhtml"])
    // (xdgAssociations "x-scheme-handler" browser ["about" "ftp" "http" "https" "unknown"]);

  associations =
    {
      "application/pdf" = ["org.gnome.Papers.desktop"];
      "application/zip" = ["org.gnome.FileRoller.desktop"];
      "application/x-7z-compressed" = ["org.gnome.FileRoller.desktop"];
      "application/x-rar-compressed" = ["org.gnome.FileRoller.desktop"];
      "application/x-tar" = ["org.gnome.FileRoller.desktop"];
      "application/gzip" = ["org.gnome.FileRoller.desktop"];
      "text/html" = browser;
      "text/plain" = ["org.gnome.TextEditor.desktop"];
      "text/markdown" = ["org.gnome.TextEditor.desktop"];
      "x-scheme-handler/chrome" = ["helium.desktop"];
    }
    // image // video // audio // browserTypes;

  userDirsConfig = pkgs.writeText "user-dirs.dirs" ''
    XDG_DESKTOP_DIR="$HOME/Desktop"
    XDG_DOWNLOAD_DIR="$HOME/Downloads"
    XDG_TEMPLATES_DIR="$HOME/Templates"
    XDG_PUBLICSHARE_DIR="$HOME/Public"
    XDG_DOCUMENTS_DIR="$HOME/Documents"
    XDG_MUSIC_DIR="$HOME/Music"
    XDG_PICTURES_DIR="$HOME/Pictures"
    XDG_VIDEOS_DIR="$HOME/Videos"
  '';
in {
  users.users.oxod.packages = with pkgs; [
    xdg-utils
    (writeShellScriptBin "xdg-terminal-exec" ''foot start "$@"'')
  ];

  xdg = {
    mime = {
      enable = true;
      defaultApplications = associations;
    };
    configFile."user-dirs.dirs".source = userDirsConfig;
    configFile."mimeapps.list".text = ''
      [Default Applications]
      ${lib.concatStringsSep "\n" (lib.mapAttrsToList (k: v: "${k}=${lib.concatStringsSep ";" v}") associations)}
      [Added Associations]
      ${lib.concatStringsSep "\n" (lib.mapAttrsToList (k: v: "${k}=${lib.concatStringsSep ";" v}") associations)}
    '';
  };
}
