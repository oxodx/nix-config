{...}: {
  plugins.lint = {
    enable = true;
    lintersByFt.nix = ["deadnix" "statix"];
  };
}
