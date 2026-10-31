{pkgs, ...}: {
  users.users.oxod.packages = with pkgs; [zoxide];

  xdg.configFile."fish/conf.d/zoxide.fish".source = pkgs.runCommand "zoxide-fish-init" {} ''
    ${pkgs.zoxide}/bin/zoxide init fish > $out
  '';
}
