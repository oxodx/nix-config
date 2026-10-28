{lib, ...}: {
  relativeToRoot = lib.path.append ../.;

  scanPaths = path:
    builtins.map (f: (path + "/${f}")) (builtins.attrNames (
      lib.attrsets.filterAttrs (
        path: _type:
          (_type == "directory")
          || (
            (path != "default.nix")
            && (lib.strings.hasSuffix ".nix" path)
          )
      ) (builtins.readDir path)
    ));

  # Package builders are functions, so they belong in lib rather than packages.
  mkWebApp = pkgs: pkgs.callPackage ../pkgs/webApp {};
}
