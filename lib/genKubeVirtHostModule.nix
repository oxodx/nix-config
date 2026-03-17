{
  pkgs,
  hostName,
  ...
}: {
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
    "kvm-amd"
    "vfio-pci"
  ];
  boot.extraModprobeConfig = "options kvm_amd nested=1"; # for amd cpu

  boot.kernel.sysctl = {
    # --- filesystem --- #
    # increase the limits to avoid running out of inotify watches
    "fs.inotify.max_user_watches" = 524288;
    "fs.inotify.max_user_instances" = 1024;

    # --- network --- #
    "net.bridge.bridge-nf-call-iptables" = 1;
    "net.core.somaxconn" = 32768;

    # ----- IPv4 ----- #
    "net.ipv4.ip_forward" = 1; # Enable forwarding
    "net.ipv4.conf.all.forwarding" = 1;
    "net.ipv4.neigh.default.gc_thresh1" = 4096;
    "net.ipv4.neigh.default.gc_thresh2" = 6144;
    "net.ipv4.neigh.default.gc_thresh3" = 8192;
    "net.ipv4.neigh.default.gc_interval" = 60;
    "net.ipv4.neigh.default.gc_stale_time" = 120;
    # ----- IPv6 ----- #
    "net.ipv6.conf.all.forwarding" = 1; # Enable forwarding

    # --- memory --- #
    "vm.swappiness" = 0; # don't swap unless absolutely necessary
  };

  environment.systemPackages = with pkgs; [
    # Validate Hardware Virtualization Support via:
    #   virt-host-validate qemu
    libvirt
    kubevirt # virtctl

    # used by kubernetes' ovs-cni plugin
    # https://github.com/k8snetworkplumbingwg/multus-cni
    multus-cni
  ];

  # Workaround for longhorn running on NixOS
  # https://github.com/longhorn/longhorn/issues/2166
  systemd.tmpfiles.rules = [
    "L+ /usr/local/bin - - - - /run/current-system/sw/bin/"
  ];
  # Longhorn uses open-iscsi to create block devices.
  services.openiscsi = {
    name = "iqn.2020-08.org.linux-iscsi.initiatorhost:${hostName}";
    enable = true;
  };

  networking = {
    inherit hostName;

    # we use networkd instead
    networkmanager.enable = false;
    useDHCP = false;
  };
  networking.useNetworkd = true;
  systemd.network.enable = true;

  # Enable the Open vSwitch as a systemd service
  # It's required by kubernetes' ovs-cni plugin.
  virtualisation.vswitch = {
    enable = true;
    # reset the Open vSwitch configuration database to a default configuration on every start of the systemd ovsdb.service
    resetOnStart = false;
  };

  # systemd.services."systemd-networkd".environment.SYSTEMD_LOG_LEVEL = "debug";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?
}
