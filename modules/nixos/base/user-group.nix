{
  users.mutableUsers = false;

  users.groups = {
    "oxod" = { };
    podman = { };
    wireshark = { };
    adbusers = { };
    dialout = { };
    plugdev = { };
    uinput = { };
  };

  users.users = {
    oxod = {
      initialPassword = "placeholder";
      home = "/home/oxod";
      isNormalUser = true;
      extraGroups = [
        "oxod"
        "users"
        "wheel"
        "networkmanager"
        "podman"
        "wireshark"
        "adbusers"
        "libvirtd"
      ];
    };

    root = {
      initialPassword = "placeholder";
    };
  };
}
