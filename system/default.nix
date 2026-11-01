{
  mylib,
  inputs,
  ...
}: let
  base = [
    inputs.agenix.nixosModules.default
    (mylib.relativeToRoot "secrets")
    (mylib.relativeToRoot "system/core")
    (mylib.relativeToRoot "system/nix")
  ];

  desktop = base ++ [
    (mylib.relativeToRoot "system/core/boot.nix")
    (mylib.relativeToRoot "system/core/limine.nix")
    (mylib.relativeToRoot "system/networking")
    (mylib.relativeToRoot "system/programs")
    (mylib.relativeToRoot "system/services")
    (mylib.relativeToRoot "system/hardware/fwupd.nix")
    (mylib.relativeToRoot "system/hardware/graphics.nix")
  ];

  laptop = desktop ++ [
    (mylib.relativeToRoot "system/hardware/bluetooth.nix")
    (mylib.relativeToRoot "system/services/power.nix")
  ];

  server = base ++ [
    (mylib.relativeToRoot "system/programs/fish.nix")
  ];
in {
  inherit
    base
    desktop
    laptop
    server;
}
