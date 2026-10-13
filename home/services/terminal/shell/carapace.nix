{
  config,
  pkgs,
  ...
}: {
  users.users.oxod.packages = with pkgs; [
    carapace
    carapace-bridge
    zsh
    bash
    inshellisense
  ];

  environment.sessionVariables = {
    CARAPACE_BRIDGES = "fish,zsh,bash,inshellisense";
    CARAPACE_CACHE_DIR = "${config.xdg.cacheHome}/carapace";
  };

  xdg.configFile."carapace/carapace.toml".text = ''
    [integrations.fish]
    enabled = true
  '';

  xdg.configFile."fish/completions/carapace.fish".source = pkgs.runCommand "carapace-fish-init" {} ''
    ${pkgs.carapace}/bin/carapace _carapace fish > $out
  '';
}
