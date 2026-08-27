let
  vars = import ./_variables.nix;
in {
  nixflix = {
    lidarr = {
      enable = true;
      openFirewall = true;
      vpn.enable = true;
      mediaDirs = ["/mnt/media/library/music"];
      config = {
        apiKey._secret = vars.secrets.lidarr.apiKey;
        hostConfig = {
          username = "oxod";
          password._secret = vars.secrets.lidarr.password;
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
