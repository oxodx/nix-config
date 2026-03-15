{ pkgs, ... }:
{
  boot.kernelModules = [ "vfio-pci" ];

  services.flatpak.enable = true;

  virtualisation = {
    docker.enable = false;
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
      autoPrune = {
        enable = true;
        dates = "weekly";
        flags = [ "--all" ];
      };
    };

    oci-containers = {
      backend = "podman";
    };
  };

  environment.systemPackages = with pkgs; [
    qemu_kvm
    qemu
  ];
}
