{
  imports = [
    ./hardware.nix
    ../../system/core/time.nix
  ];

  services = {
    asusd.enable = true;
    supergfxd.enable = true;
  };

  networking.hostName = "laptop";

  system.stateVersion = "26.05";
}
