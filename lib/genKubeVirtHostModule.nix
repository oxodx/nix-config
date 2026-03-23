{
  lib,
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
    #"zfs"
    "ntfs"
    "fat"
    "vfat"
    "exfat"
    "nfs" # required by longhorn
  ];

  boot.kernelModules = [
    "vfio-pci"
  ];

  boot.kernel.sysctl = {
    # --- filesystem --- #
    "fs.inotify.max_user_watches" = 524288;
    "fs.inotify.max_user_instances" = 1024;

    # --- network --- #
    "net.bridge.bridge-nf-call-iptables" = 1;
    "net.core.somaxconn" = 32768;

    # ----- IPv4 ----- #
    "net.ipv4.ip_forward" = 1;
    "net.ipv4.conf.all.forwarding" = 1;
    "net.ipv4.neigh.default.gc_thresh1" = 4096;
    "net.ipv4.neigh.default.gc_thresh2" = 6144;
    "net.ipv4.neigh.default.gc_thresh3" = 8192;
    "net.ipv4.neigh.default.gc_interval" = 60;
    "net.ipv4.neigh.default.gc_stale_time" = 120;
    # ----- IPv6 ----- #
    "net.ipv6.conf.all.forwarding" = 1;

    # --- memory --- #
    "vm.swappiness" = lib.mkForce 0;
  };

  environment.systemPackages = with pkgs; [
    libvirt
    kubevirt
    multus-cni
  ];

  systemd.tmpfiles.rules = [
    "L+ /usr/local/bin - - - - /run/current-system/sw/bin/"
  ];

  services.openiscsi = {
    name = "iqn.2020-08.org.linux-iscsi.initiatorhost:${hostName}";
    enable = true;
  };

  networking = {
    inherit hostName;
    networkmanager.enable = true;
    useDHCP = false;
  };

  virtualisation.vswitch = {
    enable = true;
    resetOnStart = false;
  };

  system.stateVersion = "25.11";
}
