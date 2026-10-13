{pkgs, ...}: {
  imports = [
    ./mpv.nix
    ./obs.nix
    ./rnnoise.nix
    ./yt-dlp.nix
  ];

  users.users.oxod.packages = with pkgs; [
    alsa-utils
    easyeffects
  ];
}
