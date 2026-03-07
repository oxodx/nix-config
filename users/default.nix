{ config, lib, pkgs, ... }:
let
  cfg = config.my.home-manager;
in
{
  options.my.home-manager.enabled-users = with lib; mkOption {
    type = with types; listOf str;
    description = "List of users to include home manager configs for";
    default = [ ];
  };

  config = {
    home-manager = {
      backupFileExtension = "hmbak";
    };
  } // lib.mkIf (builtins.elem "oxod" cfg.enabled-users) {
    home-manager.users = {
      oxod = ./oxod;
    };

    users.users.oxod = {
      isNormalUser = true;
      shell = pkgs.fish;
      initialPassword = "placeholder";
      extraGroups = [
        "wheel"
        "docker"
        "video"
        "audio"
      ];
    };
  };
}
