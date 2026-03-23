{
  myvars,
  config,
  ...
}:
{
  # Don't allow mutation of users outside the config.
  users.mutableUsers = false;

  users.groups = {
    "${myvars.username}" = { };
    podman = { };
    docker = { };
    wireshark = { };
    # for android platform tools's udev rules
    adbusers = { };
    dialout = { };
    # for openocd (embedded system development)
    plugdev = { };
    # misc
    uinput = { };
    # shared group for services that read/write the same data directory
    # (e.g. sftpgo + transmission on aquamarine)
    fileshare = { };
  };

  users.users."${myvars.username}" = {
    inherit (myvars) initialHashedPassword;
    home = "/home/${myvars.username}";
    isNormalUser = true;
    extraGroups = [
      myvars.username
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

  users.users.root = {
    inherit (myvars) initialHashedPassword;
    openssh.authorizedKeys.keys = myvars.mainSshAuthorizedKeys ++ myvars.secondaryAuthorizedKeys;
  };
}
