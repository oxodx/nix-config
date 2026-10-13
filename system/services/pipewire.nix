{pkgs, ...}: {
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    jack.enable = true;
    pulse.enable = true;

    wireplumber = {
      enable = true;
      configPackages = [
        (pkgs.writeTextDir "share/wireplumber/bluetooth.lua.d/51-bluez-config.lua" ''
          bluez_monitor.properties = {
            ["bluez5.enable-sbc-xq"] = true,
            ["bluez5.enable-msbc"] = true,
            ["bluez5.enable-hw-volume"] = true,
            ["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]",
            ["bluez5.a2dp.ldac.quality"] = "auto",
            ["bluez5.a2dp.aac.bitratemode"] = 0,
            ["bluez5.default.rate"] = 48000,
            ["bluez5.default.channels"] = 2,
            ["bluez5.headset-profile"] = "a2dp-only"
          }
        '')
        (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/90-mic-protect.conf" ''
          access.rules = [
            {
              matches = [ { application.process.binary = "*" } ]
              actions = { update-props = { default_permissions = "rx" } }
            }
          ]
        '')
      ];
    };

    extraConfig.pipewire."99-custom" = {
      "context.properties" = {
        default.clock = {
          rate = 48000;
          quantum = 1024;
          min-quantum = 32;
          max-quantum = 2048;
        };
      };
    };
  };
}
