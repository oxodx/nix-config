{
  # required by preservation
  fileSystems."/persistent".neededForBoot = true;
  disko.devices = {
    nodev."/" = {
      fsType = "tmpfs";
      mountOptions = [
        "size=4G"
        "defaults"
        "mode=755"
      ];
    };
    disk.main = {
      type = "disk";
      device = "/dev/sda";
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
                  mountpoint = "/btr_pool";
                  mountOptions = [ "subvolid=5" ];
                };
                "@apps" = {
                  mountpoint = "/data/apps";
                  mountOptions = [
                    "compress-force=zstd:1"
                    # https://www.freedesktop.org/software/systemd/man/latest/systemd.mount.html
                    "nofail"
                  ];
                };
                "@nix" = {
                  mountpoint = "/nix";
                  mountOptions = [
                    "compress-force=zstd:1"
                    "noatime"
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
  };
}
