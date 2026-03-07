{ lib, ... }:
{
  disko.devices = {
    disk = {
      main = {
        device = "/dev/disk/by-id/nvme-WD_PC_SN740_SDDPNQD-512G-1102_24083N801537";
        type = "disk";
        partitions = {
          esp = {
            type = "ESP";
            start = "1MiB";
            end = "600MiB";
            format = {
              vfat = {
                uuid = "FF61-5A8D";
              };
            };
          };
          luks = {
            type = "linux_luks";
            start = "600MiB";
            format = {
              luks = {
                name = "crypted-nixos";
              };
            };
          };
        };
      };
    };
    luks = {
      crypted-nixos = {
        device = "/dev/disk/by-id/nvme-WD_PC_SN740_SDDPNQD-512G-1102_24083N801537-part2";
        content = {
          type = "btrfs";
          extraArgs = ["-f"];
          subvolumes = {
            "/swap" = {
              mountpoint = "/swap";
              mountOptions = ["compress=zstd" "noatime"];
            };
            "/snapshots" = {
              mountpoint = "/snapshots";
              mountOptions = ["compress=zstd" "noatime"];
            };
            "/home" = {
              mountpoint = "/home";
              mountOptions = ["compress=zstd" "noatime"];
              subvolumes = {
                "/home/oxod" = {
                  mountpoint = "/home/oxod";
                  mountOptions = ["compress=zstd" "noatime"];
                };
              };
            };
            "/" = {
              mountpoint = "/";
              mountOptions = ["compress=zstd" "noatime"];
            };
          };
        };
      };
    };
  };
}
