{
  # NOTE: the args not used in this file CAN NOT be removed!
  # because haumea pass argument lazily,
  # and these arguments are used in the functions like `mylib.nixosSystem`, `mylib.colmenaSystem`, etc.
  inputs,
  lib,
  mylib,
  myvars,
  system,
  genSpecialArgs,
  ...
}@args:
let
  name = "kubevirt-homelab";
  tags = [
    name
    "virt-homelab"
  ];
  ssh-user = "root";

  modules = {
    nixos-modules = (
      map mylib.relativeToRoot [
        "modules/nixos/server/server.nix"
        "hosts/k8s/${name}"
      ]
    );
  };

  systemArgs = modules // args;
in
{
  nixosConfigurations.${name} = mylib.nixosSystem systemArgs;

  colmena.${name} = mylib.colmenaSystem (systemArgs // { inherit tags ssh-user; });

  packages.${name} = inputs.self.nixosConfigurations.${name}.config.formats.iso;
}
