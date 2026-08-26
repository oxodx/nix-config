let
  vars = import ./_variables.nix;
in {
  nixflix = {
    sonarr-anime = {
      enable = true;
      openFirewall = true;
      mediaDirs = ["/mnt/media/library/anime"];
      config = {
        apiKey._secret = vars.secrets.sonarr-anime.apiKey;
        hostConfig = {
          username = "oxod";
          password._secret = vars.secrets.sonarr-anime.password;
        };
        delayProfiles = [
          {
            enableUsenet = true;
            enableTorrent = true;
            preferredProtocol = "torrent";
            usenetDelay = 0;
            torrentDelay = 0;
            bypassIfHighestQuality = true;
            bypassIfAboveCustomFormatScore = false;
            minimumCustomFormatScore = 0;
            order = 2147483647;
            tags = [];
            id = 1;
          }
        ];
      };
    };
  };
}
