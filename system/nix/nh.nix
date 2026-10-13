_: {
  environment.variables.NH_FLAKE = "/home/oxod/dev/nix-config";

  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      extraArgs = "--keep-since 7d";
    };
  };
}
