{
  disko.devices = {
    disk.system = {
      type = "disk";
      device = "/dev/disk/by-id/ata-WDC_WDS240G2G0A-00JH30_2027FS469508";
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
                  swap.swapfile.size = "8096M";
                };
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
      };
    };
  };
}
