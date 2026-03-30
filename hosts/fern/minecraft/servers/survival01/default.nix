{ pkgs, lib, ... }:
let
  serverVersion = "1_21_11";
in
{
  services.minecraft-servers.servers.survival01 = {
    enable = true;
    enableReload = true;

    package = pkgs.lazymc;
    jvmOpts = "start";
    whitelist = import ../whitelist.nix;
    operators = import ../operators.nix;
    serverProperties = {
      server-port = 25581;
      white-list = true;
      online-mode = false;
      max-tick-time = -1;
      network-compression-threshold = 256;
      simulation-distance = 4;
      view-distance = 8;
    };

    symlinks = {
      "plugins/Spark.jar" = pkgs.fetchurl rec {
        pname = "spark";
        version = "1.10.172";
        url = "https://ci.lucko.me/job/${pname}/524/artifact/${pname}-bukkit/build/libs/${pname}-${version}-bukkit.jar";
        hash = "sha256:4a37b57559f00c6eea84ee9f026316135b45312748676a1b2640b13c2b844cbd";
      };
      "plugins/Chunky.jar" = pkgs.fetchurl rec {
        pname = "Chunky";
        version = "1.4.40";
        url = "https://cdn.modrinth.com/data/fALzjamp/versions/P3y2MXnd/${pname}-Bukkit-${version}.jar";
        hash = "sha256:2a5477fc80f71012e15ade1ce34dbeb836e17623b28db112492c0f1443c09721";
      };
      "plugins/ViaVersion.jar" = pkgs.fetchurl rec {
        pname = "ViaVersion";
        version = "5.8.0";
        url = "https://github.com/ViaVersion/${pname}/releases/download/${version}/${pname}-${version}.jar";
        hash = "sha256:5c9fd2ab9b3d985e91a98f3fc9872a1817d3e6260a0668c69d786ed4bba6b202";
      };
      "plugins/ViaBackwards.jar" = pkgs.fetchurl rec {
        pname = "ViaBackwards";
        version = "5.8.0";
        url = "https://github.com/ViaVersion/${pname}/releases/download/${version}/${pname}-${version}.jar";
        hash = "sha256:eb79a8616530f6ef5d3e489f0f41d1948e8df25fa9d94612c3b570eef7bbef16";
      };
    };

    files = {
      "lazymc.toml".value = {
        config.version = pkgs.lazymc.version;
        public.address = "${cfg.serverProperties.server-ip}:${toString cfg.serverProperties.server-port}";
        server = {
          address = "0.0.0.0:${toString (cfg.serverProperties.server-port - 10)}";
          command = "${lib.getExe pkgs.paperServers."paper-${serverVersion}"} ${
            ((import ../../aikar-flags.nix) "2G") + "-Dpaper.disableChannelLimit=true"
          }";
          directory = ".";
          freeze_process = true;
          probe_on_start = true;
          time.sleep_after = 60;
        };
        join.methods = [ "kick" ];
      };

      "config/paper-world-defaults.yml".value = {
        despawn-ranges = {
          ambient = {
            hard = 128;
            soft = 32;
          };
          creature = {
            hard = 128;
            soft = 32;
          };
          monster = {
            hard = 128;
            soft = 32;
          };
          axolotls = {
            hard = 72;
            soft = 30;
          };
          misc = {
            hard = 72;
            soft = 30;
          };
          underground_water_creature = {
            hard = 72;
            soft = 30;
          };
          water_ambient = {
            hard = 72;
            soft = 30;
          };
          water_creature = {
            hard = 72;
            soft = 30;
          };
        };
        per-player-mob-spawns = true;
        max-entity-collisions = 2;
        update-pathfinding-on-block-update = false;
        fix-climbing-bypassing-cramming-rule = true;
        armor-stands.tick = false;
        armor-stands.do-collision-entity-lookups = false;
        tick-rates = {
          behavior.villager = {
            validatenearbypoi = 60;
            acquirepoi = 120;
          };
          sensor.villager = {
            secondarypoisensor = 80;
            nearestbedsensor = 80;
            villagerbabiessensor = 40;
            playersensor = 40;
            nearestlivingentitysensor = 40;
          };
        };
        alt-item-despawn-rate = {
          enabled = true;
          items = {
            cobblestone = 600;
            netherrack = 600;
            sand = 600;
            red_sand = 600;
            gravel = 600;
            dirt = 600;
            short_grass = 600;
            pumpkin = 600;
            melon_slice = 600;
            kelp = 600;
            bamboo = 600;
            sugar_cane = 600;
            twisting_vines = 600;
            weeping_vines = 600;
            oak_leaves = 600;
            spruce_leaves = 600;
            birch_leaves = 600;
            jungle_leaves = 600;
            acacia_leaves = 600;
            dark_oak_leaves = 600;
            mangrove_leaves = 600;
            cherry_leaves = 600;
            cactus = 600;
            diorite = 600;
            granite = 600;
            andesite = 600;
            scaffolding = 600;
          };
        };
        redstone-implementation = "ALTERNATE_CURRENT";
        "hopper.disable-move-event" = true;
        "hopper.ignore-occluding-blocks" = true;
        "tick-rates.mob-spawner" = 2;
        optimize-explosions = true;
        "treasure-maps.enabled" = true;
        "treasure-maps.find-already-discovered" = {
          loot-tables = true;
          villager-trade = true;
        };
        "tick-rates.grass-spread" = 8;
        "tick-rates.container-update" = 2;
        non-player-arrow-despawn-rate = 20;
        creative-arrow-despawn-rate = 20;
      };
      "spigot.yml".value = {
        settings.bungeecord = true;
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
        mob-spawn-range = 3;
        tick-inactive-villagers = false;
        nerf-spawner-mobs = true;
        entity-activation-range = {
          animals = 32;
          monsters = 32;
          villagers = 32;
          misc = 16;
          water = 24;
          raiders = 48;
          flying-monsters = 48;
        };
        entity-tracking-range = {
          players = 48;
          animals = 48;
          monsters = 48;
          misc = 32;
          other = 64;
        };
        merge-radius = {
          item = 3.5;
          exp = 4.0;
        };
        hopper-transfer = 8;
        hopper-check = 8;
      };
      "bukkit.yml".value = {
        spawn-limits = {
          monsters = 50;
          animals = 15;
          water-animals = 8;
          water-ambient = 8;
          water-underground-creature = 3;
          axolotls = 5;
          ambient = 3;
        };
        ticks-per = {
          monster-spawns = 10;
          animal-spawns = 400;
          water-spawns = 400;
          water-ambient-spawns = 400;
          water-underground-creature-spawns = 400;
          axolotl-spawns = 400;
          ambient-spawns = 400;
        };
      };
      "plugins/ViaVersion/config.yml".value = {
        checkforupdates = false;
      };
      "config/paper-global.yml".value = {
        proxies.bungeecord.online-mode = true;
      };
    };
  };
}
