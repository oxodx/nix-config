{lib, ...}: {
  relativeToRoot = lib.path.append ../.;
  scanPaths = path:
    map (f: (path + "/${f}")) (
      builtins.attrNames (
        lib.attrsets.filterAttrs (
          path: _type:
            !(lib.strings.hasPrefix "_" path) # Skip private dirs/files
            && (
              (_type == "directory") # Include directories
              || (
                (path != "default.nix") # Ignore default.nix
                && (lib.strings.hasSuffix ".nix" path) # Include .nix files
              )
            )
        ) (builtins.readDir path)
      )
    );
}
