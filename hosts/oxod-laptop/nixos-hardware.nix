{
  inputs,
  config,
  lib,
  ...
}: {
  imports = [
    "${inputs.nixos-hardware}/common/cpu/amd"
    "${inputs.nixos-hardware}/common/cpu/amd/pstate.nix"
    "${inputs.nixos-hardware}/common/gpu/nvidia"
    "${inputs.nixos-hardware}/common/pc/laptop"
    "${inputs.nixos-hardware}/common/pc/ssd"
    "${inputs.nixos-hardware}/asus/battery.nix"
  ];

  hardware.nvidia = {
    modesetting.enable = lib.mkDefault true;
    open = lib.mkIf (lib.versionAtLeast config.hardware.nvidia.package.version "555") true;
  };

  hardware.asus.battery = {
    chargeUpto = 90;
    enableChargeUptoScript = true;
  };
}
