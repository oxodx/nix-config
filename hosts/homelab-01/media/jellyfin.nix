{
  lib,
  pkgs,
  mylib,
  config,
  ...
}: let
  vars = import ./_variables.nix;
  jellyfinPlugins = import (mylib.relativeToRoot "lib/jellyfinPlugins.nix") {inherit lib;};
in {
  nixflix = {
    jellyfin = {
      enable = true;
      openFirewall = true;
      apiKey._secret = vars.secrets.jellyfin.apiKey;
      network.enableRemoteAccess = true;

      branding = {
        customCss =
          if config.nixflix.theme.enable
          then ''@import url("https://theme-park.dev/css/base/jellyfin/${config.nixflix.theme.name}.css");''
          else "";
        loginDisclaimer = "";
        splashscreenEnabled = false;
        splashscreenLocation = [];
      };

      users = {
        oxod = {
          mutable = false;
          policy.isAdministrator = true;
          password._secret = vars.secrets.jellyfin.passwords.oxod;
        };
      };

      libraries = let
        subtitleSettings = {
          subtitleDownloadLanguages = [
            "eng"
            "nl"
          ];
          requirePerfectSubtitleMatch = true;
        };
      in {
        Shows =
          subtitleSettings
          // {
            collectionType = "tvshows";
            paths = ["/mnt/media/library/shows"];
            typeOptions = [
              {
                type = "Series";
                imageFetchers = ["TheMovieDb"];
                imageFetcherOrder = ["TheMovieDb"];
                metadataFetchers = [
                  "TheMovieDb"
                  "The Open Movie Database"
                ];
                metadataFetcherOrder = [
                  "TheMovieDb"
                  "The Open Movie Database"
                ];
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
                metadataFetchers = [
                  "TheMovieDb"
                  "The Open Movie Database"
                ];
                metadataFetcherOrder = [
                  "TheMovieDb"
                  "The Open Movie Database"
                ];
              }
            ];
          };
        Anime =
          subtitleSettings
          // {
            collectionType = "tvshows";
            paths = ["/mnt/media/library/anime"];
            typeOptions = [
              {
                type = "Series";
                imageFetchers = [
                  "AniDB"
                  "AniSearch"
                  "TheMovieDb"
                ];
                imageFetcherOrder = [
                  "AniDB"
                  "AniSearch"
                  "TheMovieDb"
                ];
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
                imageFetchers = [
                  "AniDB"
                  "AniSearch"
                  "TheMovieDb"
                ];
                imageFetcherOrder = [
                  "AniDB"
                  "AniSearch"
                  "TheMovieDb"
                ];
                metadataFetchers = [
                  "AniDB"
                  "TheMovieDb"
                ];
                metadataFetcherOrder = [
                  "AniDB"
                  "TheMovieDb"
                ];
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
        Movies =
          subtitleSettings
          // {
            collectionType = "movies";
            paths = ["/mnt/media/library/movies"];
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
                metadataFetchers = [
                  "TheMovieDb"
                  "The Open Movie Database"
                ];
                metadataFetcherOrder = [
                  "TheMovieDb"
                  "The Open Movie Database"
                ];
              }
            ];
          };
        Music = {
          collectionType = "music";
          paths = ["/mnt/media/library/music"];
        };
      };

      system.pluginRepositories = {
        "Intro Skipper" = {
          url = "https://raw.githubusercontent.com/intro-skipper/manifest/d56c137ae182c04a894dd700c25b04c8d2eba855/10.11/manifest.json";
          hash = "sha256-ENwn7Ei3WU2REcxnFNwzF6NGFUcnH2kJ4E5TKbpcDII=";
        };
      };

      plugins = {
        subbuzz = {
          enable = true;

          config = {
            EnableOpenSubtitles = false;
            EnableYifySubtitles = true;
            Cache.SubLifeInMinutes = "Always";
          };
        };

        "Subtitle Extract" = {
          enable = true;
          config.ExtractionDuringLibraryScan = true;
        };

        "Intro Skipper" = {
          package = jellyfinPlugins.fromRepo {
            version = "1.10.11.17";
            hash = "sha256-cfEnLqKeEGpQSth3NPjDnxCkgv2pePfgCXfVIOrYSiQ=";
          };
          config = {
            ExcludeSeries = "";
            AutoDetectIntros = true;
            AnalyzeSeasonZero = false;
            PreferChromaprint = false;
            CacheFingerprints = true;
            UseAlternativeBlackFrameAnalyzer = false;
            UpdateMediaSegments = true;
            RebuildMediaSegments = true;
            ScanIntroduction = true;
            ScanCredits = true;
            ScanRecap = true;
            ScanPreview = true;
            ScanCommercial = false;
            AnalysisPercent = "25";
            AnalysisLengthLimit = "10";
            FullLengthChapters = false;
            SkipFirstEpisode = false;
            SkipFirstEpisodeAnime = false;
            MinimumIntroDuration = "15";
            MaximumIntroDuration = "120";
            MinimumCreditsDuration = "15";
            MaximumCreditsDuration = "450";
            MaximumMovieCreditsDuration = "900";
            MinimumRecapDuration = "15";
            MaximumRecapDuration = "120";
            MinimumPreviewDuration = "15";
            MaximumPreviewDuration = "120";
            MinimumCommercialDuration = "15";
            MaximumCommercialDuration = "120";
            BlackFrameMinimumPercentage = "85";
            BlackFrameThreshold = "28";
            UseChapterMarkersBlackFrame = true;
            AdjustIntroBasedOnChapters = true;
            AdjustIntroBasedOnSilence = true;
            SnapToKeyframe = true;
            EndSnapThreshold = "2";
            AdjustWindowInward = "5";
            AdjustWindowOutward = "2";
            ChapterAnalyzerIntroductionPattern = "(^|\\s)(Intro|Introduction|OP|Opening)(?!\\sEnd)(\\s|$)";
            ChapterAnalyzerEndCreditsPattern = "(^|\\s)(Credits?|ED|Ending|Outro)(?!\\sEnd)(\\s|$)";
            ChapterAnalyzerPreviewPattern = "(^|\\s)(Preview|PV|Sneak\\s?Peek|Coming\\s?(Up|Soon)|Next\\s+(time|on|episode)|Extra|Teaser|Trailer)(?!\\sEnd)(\\s|:|$)";
            ChapterAnalyzerRecapPattern = "(^|\\s)(Re?cap|Sum{1,2}ary|Prev(ious(ly)?)?|(Last|Earlier)(\\s\\w+)?|Catch[ -]up)(?!\\sEnd)(\\s|:|$)";
            ChapterAnalyzerCommercialPattern = "(^|\\s)(Ad(vert(isement)?)?|Commercial)(?!\\sEnd)(\\s|$)";
            IntroEndOffset = "0";
            IntroStartOffset = "0";
            MaximumFingerprintPointDifferences = 6;
            MaximumTimeSkip = 3.5;
            InvertedIndexShift = 2;
            SilenceDetectionMaximumNoise = "-50";
            SilenceDetectionMinimumDuration = "0.33";
            MaxParallelism = "2";
            ProcessThreads = "0";
            ProcessPriority = "BelowNormal";
            UseFileTransformationPlugin = false;
            SkipbuttonHideDelay = "8";
            EnableMainMenu = true;
            FileTransformationPluginEnabled = false;
          };
        };
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

      metadata.useFileCreationTimeForDateAdded = false;
    };
  };
}
