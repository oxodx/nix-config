{
  pkgs,
  self,
  ...
}: {
  users.users.oxod.packages = [self.packages.${pkgs.stdenv.hostPlatform.system}.rokit];

  xdg.configFile."fish/conf.d/rokit.fish".text = ''
    fish_add_path --path --prepend "$HOME/.rokit/bin"
  '';
}
