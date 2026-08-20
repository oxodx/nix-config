{ lib, ... }: {
  relativeToRoot = lib.path.append ../.;

  toXML =
    let
      indent = level: lib.concatStrings (lib.genList (_: "  ") level);

      escapeText = s: builtins.replaceStrings [ "&" "<" ">" ] [ "&amp;" "&lt;" "&gt;" ] (toString s);

      escapeAttr =
        s:
        builtins.replaceStrings [ "&" "<" ">" "'" "\"" ] [ "&amp;" "&lt;" "&gt;" "&apos;" "&quot;" ] (
          toString s
        );

      renderAttrs =
        attrs:
        lib.concatStringsSep "" (
          lib.mapAttrsToList (name: value: " ${name}=\"${escapeAttr value}\"") attrs
        );

      render =
        level: elem:
        if builtins.isString elem then
          "${indent level}${escapeText elem}"
        else if elem ? declaration then
          "${indent level}<?xml ${renderAttrs elem.declaration}?>"
        else
          let
            tag = elem.tag;
            attrs = elem.attrs or { };
            children = elem.children or [ ];
            attrStr = renderAttrs attrs;
          in
          if children == [ ] then
            "${indent level}<${tag}${attrStr} />"
          else
            "${indent level}<${tag}${attrStr}>\n${
              lib.concatStringsSep "\n" (map (render (level + 1)) children)
            }\n${indent level}</${tag}>";
    in
    elems: lib.concatStringsSep "\n" (map (render 0) elems);

  scanPaths =
    path:
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
