{
  inputs,
  self,
  ...
}: let
  mkHost = path:
    inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs self;
        mylib = self.lib;
      };
      modules = [path];
    };
in {
  oxod-laptop = mkHost ./oxod-laptop;
  tv = mkHost ./tv;
  homelab-camelot = mkHost ./homelab/camelot;
  homelab-excalibur = mkHost ./homelab/excalibur;
  homelab-gawain = mkHost ./homelab/gawain;
}
