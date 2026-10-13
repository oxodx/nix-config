{pkgs, ...}: let
  configFile = "yt-dlp/config";
in {
  users.users.oxod.packages = with pkgs; [yt-dlp aria2];
  environment.etc."xdg/${configFile}".text = ''
    -o $HOME/Music/%(uploader)s/%(title)s.%(ext)s
    --embed-thumbnail
    --embed-metadata
    -f bestaudio/best
    --audio-format opus
    --audio-quality 0
    --continue
    --no-overwrites
    --restrict-filenames
    --sponsorblock-remove sponsor,selfpromo,interaction
    --downloader aria2c
    --downloader-args aria2c:'--continue --min-split-size=5M --max-connection-per-server=4'
  '';
}
