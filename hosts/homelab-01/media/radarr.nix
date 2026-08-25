let
  vars = import ./_variables.nix;
in {
  nixflix = {
    radarr = {
      enable = true;
      openFirewall = true;
      mediaDirs = ["/mnt/media/library/movies"];
      config = {
        apiKey._secret = vars.secrets.radarr.apiKey;
        hostConfig.password._secret = vars.secrets.radarr.password;
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
