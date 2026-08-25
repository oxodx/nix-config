{
  lib,
  pkgs,
  config,
  ...
}: {
  hardware.graphics = {
    extraPackages = with pkgs; [
      intel-media-driver
      intel-vaapi-driver
      libva-vdpau-driver
      libvpl
    ];
  };

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "i965";
  };

  nixflix = {
    enable = true;
    stateDir = "/var/lib";
    mediaDir = "/mnt/media";
    downloadsDir = "/mnt/media/downloads";
    mediaUsers = ["oxod"];

    theme = {
      enable = true;
      name = "overseerr";
    };

    nginx.enable = false;

    postgres.enable = true;

    sonarr = {
      enable = true;
      openFirewall = true;
      config = {
        apiKey._secret = "/root/secrets/sonarr/api_key";
        hostConfig.password._secret = "/root/secrets/sonarr/password";
      };
    };

    radarr = {
      enable = true;
      openFirewall = true;
      config = {
        apiKey._secret = "/root/secrets/radarr/api_key";
        hostConfig.password._secret = "/root/secrets/radarr/password";
      };
    };

    recyclarr = {
      enable = true;
      cleanupUnmanagedProfiles.enable = true;
    };

    prowlarr = {
      enable = true;
      openFirewall = true;
      config = {
        apiKey._secret = "/root/secrets/prowlarr/api_key";
        hostConfig.password._secret = "/root/secrets/prowlarr/password";
      };
    };

    seerr = {
      enable = true;
      openFirewall = true;
      apiKey._secret = "/root/secrets/seerr/api_key";
    };

    jellyfin = {
      enable = true;
      openFirewall = true;
      apiKey._secret = "/root/secrets/jellyfin/api_key";

      branding = {
        customCss =
          if config.nixflix.theme.enable
          then ''@import url("https://theme-park.dev/css/base/jellyfin/${config.nixflix.theme.name}.css");''
          else "";
        loginDisclaimer = "";
        splashscreenEnabled = false;
        splashscreenLocation = [];
      };

      encoding = {
        enableHardwareEncoding = true;
        allowHevcEncoding = false;
        allowAv1Encoding = false;
        encodingThreadCount = -1;
        transcodingTempPath = "${config.nixflix.jellyfin.cacheDir}/transcodes";
        enableFallbackFont = false;
        fallbackFontPath = "";
        enableAudioVbr = false;
        downMixAudioBoost = 2;
        downMixStereoAlgorithm = "None";
        maxMuxingQueueSize = 2048;
        enableThrottling = false;
        throttleDelaySeconds = 180;
        enableSegmentDeletion = false;
        segmentKeepSeconds = 720;
        hardwareAccelerationType = "none";
        encoderAppPathDisplay = "${pkgs.jellyfin-ffmpeg}/bin/ffmpeg";
        vaapiDevice = "/dev/dri/renderD128";
        qsvDevice = "";
        enableTonemapping = false;
        tonemappingAlgorithm = "bt2390";
        tonemappingMode = "auto";
        tonemappingRange = "auto";
        tonemappingDesat = 0;
        tonemappingPeak = 100;
        tonemappingParam = 0;
        enableVppTonemapping = false;
        enableVideoToolboxTonemapping = false;
        vppTonemappingBrightness = 16;
        vppTonemappingContrast = 1;
        h264Crf = 23;
        h265Crf = 28;
        encoderPreset = "auto";
        deinterlaceDoubleRate = false;
        deinterlaceMethod = "yadif";
        enableDecodingColorDepth10Hevc = true;
        enableDecodingColorDepth10Vp9 = true;
        enableDecodingColorDepth10HevcRext = false;
        enableDecodingColorDepth12HevcRext = false;
        enableEnhancedNvdecDecoder = true;
        preferSystemNativeHwDecoder = true;
        hardwareDecodingCodecs = [
          "h264"
          "hevc"
          "mpeg2video"
          "vc1"
        ];
        enableIntelLowPowerH264HwEncoder = true;
        enableIntelLowPowerHevcHwEncoder = true;
        enableSubtitleExtraction = true;
        allowOnDemandMetadataBasedKeyframeExtractionForExtensions = ["mkv"];
      };

      libraries = {
        Shows = {
          collectionType = "tvshows";
          paths = ["/mnt/media/library/shows"];
          typeOptions = [
            {
              type = "Series";
              imageFetchers = ["TheMovieDb"];
              imageFetcherOrder = ["TheMovieDb"];
              metadataFetchers = ["TheMovieDb" "The Open Movie Database"];
              metadataFetcherOrder = ["TheMovieDb" "The Open Movie Database"];
            }
            {
              type = "Season";
              imageFetchers = ["TheMovieDb"];
              imageFetcherOrder = ["TheMovieDb"];
              metadataFetchers = ["TheMovieDb"];
              metadataFetcherOrder = ["TheMovieDb"];
            }
            {
              type = "Episode";
              imageFetchers = [
                "TheMovieDb"
                "The Open Movie Database"
                "Embedded Image Extractor"
                "Screen Grabber"
              ];
              imageFetcherOrder = [
                "TheMovieDb"
                "The Open Movie Database"
                "Embedded Image Extractor"
                "Screen Grabber"
              ];
              metadataFetchers = ["TheMovieDb" "The Open Movie Database"];
              metadataFetcherOrder = ["TheMovieDb" "The Open Movie Database"];
            }
          ];
        };
        Anime = {
          collectionType = "tvshows";
          paths = ["/mnt/media/library/anime"];
          typeOptions = [
            {
              type = "Series";
              imageFetchers = ["AniDB" "AniSearch" "TheMovieDb"];
              imageFetcherOrder = ["AniDB" "AniSearch" "TheMovieDb"];
              metadataFetchers = [
                "AniDB"
                "AniSearch"
                "TheMovieDb"
                "The Open Movie Database"
              ];
              metadataFetcherOrder = [
                "AniDB"
                "AniSearch"
                "TheMovieDb"
                "The Open Movie Database"
              ];
            }
            {
              type = "Season";
              imageFetchers = ["AniDB" "AniSearch" "TheMovieDb"];
              imageFetcherOrder = ["AniDB" "AniSearch" "TheMovieDb"];
              metadataFetchers = ["AniDB" "TheMovieDb"];
              metadataFetcherOrder = ["AniDB" "TheMovieDb"];
            }
            {
              type = "Episode";
              imageFetchers = [
                "TheMovieDb"
                "The Open Movie Database"
                "Embedded Image Extractor"
                "Screen Grabber"
              ];
              imageFetcherOrder = [
                "TheMovieDb"
                "The Open Movie Database"
                "Embedded Image Extractor"
                "Screen Grabber"
              ];
              metadataFetchers = [
                "AniDB"
                "TheMovieDb"
                "The Open Movie Database"
              ];
              metadataFetcherOrder = [
                "AniDB"
                "TheMovieDb"
                "The Open Movie Database"
              ];
            }
          ];
        };
        Movies = {
          collectionType = "movies";
          paths = "/mnt/media/library/movies";
          typeOptions = [
            {
              type = "Movie";
              imageFetchers = [
                "TheMovieDb"
                "The Open Movie Database"
                "Embedded Image Extractor"
                "Screen Grabber"
              ];
              imageFetcherOrder = [
                "TheMovieDb"
                "The Open Movie Database"
                "Embedded Image Extractor"
                "Screen Grabber"
              ];
              metadataFetchers = ["TheMovieDb" "The Open Movie Database"];
              metadataFetcherOrder = ["TheMovieDb" "The Open Movie Database"];
            }
          ];
        };
        Music = {
          collectionType = "music";
          paths = /mnt/media/library/music;
        };
      };

      metadata.useFileCreationTimeForDateAdded = false;

      users = {
        oxod = {
          mutable = false;
          policy.isAdministrator = true;
          password._secret = "/root/secrets/jellyfin/passwords/oxod";
        };
      };
    };

    torrentClients.qbittorrent = {
      enable = true;
      vpn.enable = true;
      openFirewall = true;
    };

    vpn = {
      enable = true;
      wgConfFile = "/root/secrets/mullvad.conf";
      accessibleFrom = ["192.168.1.0/24"];
    };
  };

  networking.firewall.allowedTCPPorts = [8282];
}
