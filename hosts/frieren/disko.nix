{
  disko.devices = {
    disk.system = {
      type = "disk";
      device = "/dev/disk/by-id/ata-Samsung_SSD_850_PRO_256GB_S1SUNSAG132588E";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            size = "630M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [
                "fmask=0177"
                "dmask=0077"
                "noexec,nosuid,nodev"
              ];
            };
          };
          root = {
            size = "100%";
            content = {
              type = "btrfs";
              extraArgs = [ "-f" ];
              subvolumes = {
                "/" = {
                  mountpoint = "/";
                  mountOptions = [
                    "compress-force=zstd:1"
                    "noatime"
                  ];
                };
                "@nix" = {
                  mountpoint = "/nix";
                  mountOptions = [
                    "compress-force=zstd:1"
                    "noatime"
                  ];
                };
                "@swap" = {
                  mountpoint = "/swap";
                  swap.swapfile.size = "16384M";
                };
              };
            };
          };
        };
      };
    };
    disk.media = {
      type = "disk";
      device = "/dev/disk/by-id/ata-KINGSTON_SA400S37240G_50026B77837F81F4";
      content = {
        type = "btrfs";
        extraArgs = [ "-f" ];
        subvolumes = {
          "@media" = {
            mountpoint = "/media";
            mountOptions = [
              "compress-force=zstd:1"
              "nofail"
            ];
          };
        };
      };
    };
    disk.data = {
      type = "disk";
      device = "/dev/disk/by-id/ata-KINGSTON_SA400S37240G_50026B7380F693A8";
      content = {
        type = "btrfs";
        extraArgs = [ "-f" ];
        subvolumes = {
          "@apps" = {
            mountpoint = "/data/apps";
            mountOptions = [
              "compress-force=zstd:1"
              "nofail"
            ];
          };
          "@tmp" = {
            mountpoint = "/tmp";
            mountOptions = [
              "compress-force=zstd:1"
              "noatime"
            ];
          };
          "@snapshots" = {
            mountpoint = "/snapshots";
            mountOptions = [
              "compress-force=zstd:1"
              "noatime"
            ];
          };
        };
      };
    };
  };
}
