{lib, ...}: {
  relativeToRoot = lib.path.append ../.;

  scanPaths = path:
    map (f: (path + "/${f}")) (
      builtins.attrNames (
        lib.attrsets.filterAttrs (
          path: _type:
            !(lib.strings.hasPrefix "_" path)
            && (
              (_type == "directory")
              || (
                (path != "default.nix")
                && (lib.strings.hasSuffix ".nix" path)
              )
            )
        ) (builtins.readDir path)
      )
    );
}
