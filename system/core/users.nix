{pkgs, ...}: {
  users.users.oxod = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [
      "adbusers"
      "input"
      "networkmanager"
      "plugdev"
      "video"
      "wheel"
      "kvm"
      "i2c"
      "docker"
    ];
  };
}
