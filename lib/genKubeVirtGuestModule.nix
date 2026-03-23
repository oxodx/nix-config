{
  pkgs,
  hostName,
  ...
}:
{
  # supported file systems, so we can mount any removable disks with these filesystems
  boot.supportedFilesystems = [
    "ext4"
    "btrfs"
    "xfs"
    "fat"
    "vfat"
    "exfat"
  ];

  networking = {
    inherit hostName;

    networkmanager.enable = true;
    useDHCP = false;
  };

  system.stateVersion = "25.11"; # Did you read the comment?
}
