{ lib, ... }:
{
  disko.devices = {
    disk = {
      main = {
        device = "/dev/disk/by-uuid/02d8bae7-0af2-4f6b-9c0d-65800fc321e9";
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
        };
      };
    };
    mount = {
      "/boot" = {
        device = "/dev/disk/by-uuid/FF61-5A8D";
        format = "vfat";
      };
    };
  };
}
