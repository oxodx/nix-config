{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # System call monitoring
    strace
    ltrace
    lsof

    # Ebpf related tools
    bpftrace
    bpftop
    bpfmon

    # System monitoring
    sysstat
    iotop-c
    iftop
    nmon
    sysbench
    systemctl-tui

    # System tools
    psmisc
    lm_sensors
    ethtool
    usbutils
    hdparm
    dmidecode
    parted
    nvme-cli
  ];

  programs.bcc.enable = true;
  programs.direnv.enable = true;
}
