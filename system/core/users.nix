{pkgs, ...}: {
  users.groups = {
    oxod = {};
    podman = {};
    docker = {};
    # For android platform tool's udev rules
    adbusers = {};
    adbusers = {};
    # for openocd (embedded system development)
    plugdev = {};
    # misc
    uinput = {};
    # shared group for services that read/write the same data directory
    # (e.g. sftpgo + transmission on aquamarine)
    fileshare = {};
  };

  users.users.oxod = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [
      "users"
      "wheel"
      "networkmanager" # for nmtui / nm-connection-editor
      "podman"
      "docker"
      "wireshark"
      "adbusers" # android debugging
      "libvirtd" # virt-viewer / qemu
      "fileshare"
    ];
  };
}
