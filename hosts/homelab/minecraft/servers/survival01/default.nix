{ pkgs, ... }:
let
  serverVersion = "1_21_11";
in
{
  services.minecraft-servers.servers.survival01 = {
    enable = true;
    enableReload = true;

    package = pkgs.paperServers."paper-${serverVersion}";
    jvmOpts = ((import ../../aikar-flags.nix) "2G") + "-Dpaper.disableChannelLimit=true";
    whitelist = import ./whitelist.nix;
    serverProperties = {
      server-port = 25581;
      white-list = true;
      max-tick-time = -1;
      network-compression-threshold = 256;
      simulation-distance = 4;
      view-distance = 7;
    };

    symlinks = {
      "plugins/LuckPerms.jar" = pkgs.fetchurl rec {
        pname = "LuckPerms";
        version = "5.5.17";
        url = "https://cdn.modrinth.com/data/Vebnzrzj/versions/OrIs0S6b/${pname}-Bukkit-${version}.jar";
        hash = "sha256:d5b160a3971a8372cc5835bcd555e37c1aa61e9dd30559921a5f421a11bf97dd";
      };
      "plugins/Chunky.jar" = pkgs.fetchurl rec {
        pname = "Chunky";
        version = "1.4.40";
        url = "https://cdn.modrinth.com/data/fALzjamp/versions/P3y2MXnd/${pname}-Bukkit-${version}.jar";
        hash = "sha256:2a5477fc80f71012e15ade1ce34dbeb836e17623b28db112492c0f1443c09721";
      };
      "plugins/ViaVersion.jar" = pkgs.fetchurl rec {
        pname = "ViaVersion";
        version = "5.7.2";
        url = "https://github.com/ViaVersion/${pname}/releases/download/${version}/${pname}-${version}.jar";
        hash = "sha256:4430a127f6cb21d7a52ec6a07a5dcc43ba235acc062c86330619b8de1d4958fd";
      };
      "plugins/ViaBackwards.jar" = pkgs.fetchurl rec {
        pname = "ViaBackwards";
        version = "5.7.2";
        url = "https://github.com/ViaVersion/${pname}/releases/download/${version}/${pname}-${version}.jar";
        hash = "sha256:cbf4ce4dc132b1bcccc2abb9626ed18bb1bd116c9300657543458241b01000f7";
      };
    };

    files = {
      "spigot.yml".value = {
        view-distance = "default";
        delay-chunk-unloads-by = "10s";
        prevent-moving-into-unloaded-chunks = true;
        entity-per-chunk-save-limit = {
          area_effect_cloud = 8;
          arrow = 16;
          breeze_wind_charge = 8;
          dragon_fireball = 3;
          egg = 8;
          ender_pearl = 8;
          experience_bottle = 3;
          experience_orb = 16;
          eye_of_ender = 8;
          fireball = 8;
          firework_rocket = 8;
          llama_spit = 3;
          splash_potion = 8;
          lingering_potion = 8;
          shulker_bullet = 8;
          small_fireball = 8;
          snowball = 8;
          spectral_arrow = 16;
          trident = 16;
          wind_charge = 8;
          wither_skull = 4;
        };
      };
      "plugins/ViaVersion/config.yml".value = {
        checkforupdates = false;
      };
    };

    lazymc = {
      enable = true;
      config = {
        public.address = "0.0.0.0:25571";
      };
    };
  };
}
