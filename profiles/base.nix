{inputs, ...}: {
  imports = [
    inputs.agenix.nixosModules.default
    ../secrets
    ../system/core
    ../system/nix
  ];
}
