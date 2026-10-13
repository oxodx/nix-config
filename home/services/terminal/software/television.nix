{pkgs, ...}: {
  users.users.oxod.packages = with pkgs; [
    television
    nix-search-tv
  ];

  xdg.configFile = {
    "nix-search-tv/config.json".text = builtins.toJSON {
      indexes = ["nixos" "nixpkgs" "nur"];
    };
    "fish/completions/tv.fish".source = "${pkgs.television}/share/fish/vendor_completions.d/tv.fish";
  };
}
