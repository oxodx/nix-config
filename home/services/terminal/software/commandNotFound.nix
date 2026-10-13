{inputs, ...}: {
  imports = [inputs.nix-index-database.nixosModules.nix-index];
  programs.command-not-found.enable = false;
  programs.nix-index = {
    enable = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };
}
