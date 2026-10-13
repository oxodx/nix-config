{pkgs, ...}: {
  users.users.oxod.packages = [pkgs.nix-your-shell];

  xdg.configFile."fish/conf.d/nix-your-shell.fish".source = pkgs.runCommand "nix-your-shell-init" {} ''
    ${pkgs.nix-your-shell}/bin/nix-your-shell fish > $out
  '';
}
