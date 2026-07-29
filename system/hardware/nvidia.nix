{ config, lib, ... }: {
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware = {
    graphics.enable = lib.mkForce true;
    nvidia = {
      open = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      modesetting.enable = true;
      nvidiaSettings = true;
    };
  };
}
