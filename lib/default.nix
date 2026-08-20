{lib, ...}: {
  relativeToRoot = lib.path.append ../.;

  toXML = let
    indent = level: lib.concatStrings (lib.genList (_: "  ") level);

    escapeText = s: builtins.replaceStrings ["&" "<" ">"] ["&amp;" "&lt;" "&gt;"] (toString s);

    escapeAttr = s:
      builtins.replaceStrings ["&" "<" ">" "'" "\""] ["&amp;" "&lt;" "&gt;" "&apos;" "&quot;"] (
        toString s
      );

    renderAttrs = attrs:
      lib.concatStringsSep "" (
        lib.mapAttrsToList (name: value: " ${name}=\"${escapeAttr value}\"") attrs
      );

    render = level: elem:
      if elem ? declaration
      then "<?xml${renderAttrs elem.declaration}?>"
      else if !builtins.isAttrs elem
      then "${indent level}${escapeText (toString elem)}"
      else let
        tag = elem.tag;
        attrs = elem.attrs or {};
        children = elem.children or [];
        attrStr = renderAttrs attrs;
      in
        if children == []
        then "${indent level}<${tag}${attrStr} />"
        # Inline single string/primitive children so text nodes don't break with newlines/indentation
        else if builtins.length children == 1 && !builtins.isAttrs (builtins.head children)
        then "${indent level}<${tag}${attrStr}>${escapeText (toString (builtins.head children))}</${tag}>"
        else "${indent level}<${tag}${attrStr}>\n${
          lib.concatStringsSep "\n" (map (render (level + 1)) children)
        }\n${indent level}</${tag}>";
  in
    elems: lib.concatStringsSep "\n" (map (render 0) elems);

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
