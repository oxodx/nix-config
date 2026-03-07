{ lib, ... }: {
  disko.devices = {
    disk = {
      main = {
        device = "/dev/disk/by-id/nvme-WD_PC_SN740_SDDPNQD-512G-1102_24083N801537";
        type = "disk";
        partitions = {
          esp = {
            type = "ESP";
            start = "1MiB";
            end = "512MiB";
            format = {
              vfat = {
                uuid = "FF61-5A8D";
                attributes = "umask=0077";
              };
            };
          };
          root = {
            type = "linux";
            start = "512MiB";
            format = {
              ext4 = {
                uuid = "02d8bae7-0af2-4f6b-9c0d-65800fc321e9";
              };
            };
          };
        };
      };
    };
  };
}
