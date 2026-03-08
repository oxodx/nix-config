{ lib, config, ... }:
with lib;
let
  cfg = config.modules.base.users;
in
{
  options.modules.base.users = {
    users = mkOption {
      type = with types; listOf str;
      default = [ ];
      description = "Normal users to create on this host.";
    };
  };

  config = {
    users.mutableUsers = false;

    users.groups = {
      podman = { };
      wireshark = { };
      adbusers = { };
      dialout = { };
      plugdev = { };
      uinput = { };
    }
    // (genAttrs cfg.users (name: { }));

    users.users = {
      root = {
        initialPassword = "placeholder";
      };
    }
    // (genAttrs cfg.users (name: {
      initialPassword = "placeholder";
      home = "/home/${name}";
      isNormalUser = true;
      extraGroups = [
        name
        "users"
        "wheel"
        "networkmanager"
        "podman"
        "wireshark"
        "adbusers"
        "libvirtd"
      ];
    }));
  };
}
