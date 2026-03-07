{ lib, ... }:
{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-WD_PC_SN740_SDDPNQD-512G-1102_24083N801537";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "600M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                uuid = "FF61-5A8D";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "crypted-nixos";
                settings = {
                  allowDiscards = true;
                };
                content = {
                  type = "btrfs";
                  extraArgs = [ "-f" ];
                  subvolumes = {
                    "/swap" = {
                      mountpoint = "/swap";
                      mountOptions = [ "compress=zstd" "noatime" ];
                    };
                    "/snapshots" = {
                      mountpoint = "/snapshots";
                      mountOptions = [ "compress=zstd" "noatime" ];
                    };
                    "/home" = {
                      mountpoint = "/home";
                      mountOptions = [ "compress=zstd" "noatime" ];
                      subvolumes = {
                        "/home/oxod" = {
                          mountpoint = "/home/oxod";
                          mountOptions = [ "compress=zstd" "noatime" ];
                        };
                      };
                    };
                    "/" = {
                      mountpoint = "/";
                      mountOptions = [ "compress=zstd" "noatime" ];
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
