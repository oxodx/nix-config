{ lib, ... }:
{
  disko.devices = {
    disk = {
      main = {
        device = "/dev/disk/by-id/nvme-Samsung_SN850X_4TB_XXX";
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
