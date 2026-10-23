{
  config,
  pkgs,
  ...
}: let
  microphone = "alsa_input.usb-Nor-Tec_streaming_mic_Nor-Tec_streaming_mic_000000010000-00.analog-stereo";
in {
  systemd.user.services.nortec-microphone = {
    description = "Nor-Tec microphone cleanup";
    wantedBy = ["default.target" "pipewire.service"];
    requires = ["pipewire.service"];
    after = ["pipewire.service"];
    partOf = ["pipewire.service"];
    restartTriggers = config.services.pipewire.configPackages;
    serviceConfig = {
      ExecStartPre = "${pkgs.pipewire}/bin/pw-cli info 0";
      ExecStart = "${pkgs.pipewire}/bin/pipewire -c filter-chain.conf";
      Restart = "on-failure";
      RestartSec = 2;
    };
  };

  services.pipewire.configPackages = [
    (pkgs.writeTextDir "share/pipewire/filter-chain.conf.d/99-nortec.conf" (builtins.toJSON {
      "context.modules" = [
        {
          "name" = "libpipewire-module-filter-chain";
          "args" = {
            "node.description" = "Nor-Tec Clean";
            "media.name" = "Nor-Tec Clean";
            "audio.rate" = 48000;
            "audio.channels" = 1;
            "audio.position" = ["MONO"];
            "filter.graph" = {
              "nodes" = [
                {
                  "type" = "builtin";
                  "name" = "rumble";
                  "label" = "bq_highpass";
                  "control" = {
                    "Freq" = 90.0;
                    "Q" = 0.707;
                  };
                }
                {
                  "type" = "builtin";
                  "name" = "hiss";
                  "label" = "bq_lowpass";
                  "control" = {
                    "Freq" = 10000.0;
                    "Q" = 0.707;
                  };
                }
                {
                  "type" = "ladspa";
                  "name" = "voice";
                  "plugin" = "${pkgs.ladspaPlugins}/lib/ladspa/sc4m_1916.so";
                  "label" = "sc4m";
                  "control" = {
                    "RMS/peak" = 0.0;
                    "Attack time (ms)" = 3.0;
                    "Release time (ms)" = 120.0;
                    "Threshold level (dB)" = -30.0;
                    "Ratio (1:n)" = 4.0;
                    "Knee radius (dB)" = 6.0;
                    "Makeup gain (dB)" = 20.0;
                  };
                }
                {
                  "type" = "ladspa";
                  "name" = "limiter";
                  "plugin" = "${pkgs.ladspaPlugins}/lib/ladspa/fast_lookahead_limiter_1913.so";
                  "label" = "fastLookaheadLimiter";
                  "control" = {
                    "Input gain (dB)" = 0.0;
                    "Limit (dB)" = -1.0;
                    "Release time (s)" = 0.1;
                  };
                }
              ];
              "links" = [
                {
                  output = "rumble:Out";
                  input = "hiss:In";
                }
                {
                  output = "hiss:Out";
                  input = "voice:Input";
                }
                {
                  output = "voice:Output";
                  input = "limiter:Input 1";
                }
                {
                  output = "voice:Output";
                  input = "limiter:Input 2";
                }
              ];
              "inputs" = ["rumble:In"];
              "outputs" = ["limiter:Output 1"];
            };
            "capture.props" = {
              "node.name" = "capture.nortec-clean";
              "node.passive" = true;
              "target.object" = microphone;
              "node.dont-fallback" = true;
            };
            "playback.props" = {
              "node.name" = "nortec-clean";
              "node.description" = "Nor-Tec Clean";
              "media.class" = "Audio/Source";
              "priority.session" = 3000;
            };
          };
        }
      ];
    }))
  ];
}
