# Maybe apply some security patches from
# https://github.com/linuxmobile/shin/blob/4fdb8a49ad03b7816a9e25a82a374128e9c4ea85/system/core/security.nix
{
  security = {
    rtkit.enable = true;
    polkit.enable = true;

    sudo-rs = {
      enable = true;
      execWheelOnly = true;
      wheelNeedsPassword = false;
    };

    sudo.wheelNeedsPassword = false;
  };
}
