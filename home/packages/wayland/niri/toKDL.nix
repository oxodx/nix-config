{
  lib,
  pkgs,
}: let
  inherit
    (lib)
    concatStringsSep
    splitString
    mapAttrsToList
    any
    optionalString
    pipe
    filterAttrs
    ;
  inherit (builtins) typeOf replaceStrings elem;

  indentStrings = let
    unlines = splitString "\n";
    lines = concatStringsSep "\n";
    indentAll = lines: concatStringsSep "\n" (map (x: "    " + x) lines);
  in
    stringsWithNewlines: indentAll (unlines (lines stringsWithNewlines));

  sanitizeString = replaceStrings ["\n" ''"'' "\\" "\r" "\t"] ["\\n" ''\"'' "\\\\" "\\r" "\\t"];

  literalValueToString = element:
    lib.throwIfNot
    (elem (typeOf element) [
      "int"
      "float"
      "string"
      "bool"
      "null"
    ])
    "Cannot convert value of type ${typeOf element} to KDL literal."
    (
      if typeOf element == "null"
      then "null"
      else if element == false
      then "false"
      else if element == true
      then "true"
      else if typeOf element == "string"
      then ''"${sanitizeString element}"''
      else toString element
    );

  convertAttrsToKDL = name: attrs: let
    optArgsString = optionalString (attrs ? _args) (
      pipe attrs._args [
        (map literalValueToString)
        (concatStringsSep " ")
        (s: s + " ")
      ]
    );
    optPropsString = optionalString (attrs ? _props) (
      pipe attrs._props [
        (mapAttrsToList (name: value: "${name}=${literalValueToString value}"))
        (concatStringsSep " ")
        (s: s + " ")
      ]
    );
    children =
      filterAttrs (
        name: _:
          !(elem name [
            "_args"
            "_props"
          ])
      )
      attrs;
  in
    ''${name} ${optArgsString}${optPropsString}''
    + (
      if children == {}
      then ""
      else "{\n${indentStrings (mapAttrsToList convertAttributeToKDL children)}\n}"
    );

  convertListOfFlatAttrsToKDL = name: list: let
    flatElements = map literalValueToString list;
  in "${name} ${concatStringsSep " " flatElements}";

  convertListOfNonFlatAttrsToKDL = name: list: ''${concatStringsSep "\n" (map (x: convertAttributeToKDL name x) list)}'';

  convertListToKDL = name: list: let
    elementsAreFlat =
      !any (
        el:
          elem (typeOf el) [
            "list"
            "set"
          ]
      )
      list;

    allSingleValues =
      builtins.all (
        el:
          elem (typeOf el) ["int" "float" "string" "bool" "null"]
      )
      list;

    isListOfLists = builtins.all (el: typeOf el == "list") list;
  in
    if isListOfLists
    then concatStringsSep "\n" (map (sublist: "${name} ${concatStringsSep " " (map literalValueToString sublist)}") list)
    else if elementsAreFlat && allSingleValues && builtins.length list > 1
    then concatStringsSep "\n" (map (val: "${name} ${literalValueToString val}") list)
    else if elementsAreFlat
    then convertListOfFlatAttrsToKDL name list
    else convertListOfNonFlatAttrsToKDL name list;

  convertAttributeToKDL = name: value: let
    vType = typeOf value;
  in
    if
      elem vType [
        "int"
        "float"
        "bool"
        "string"
      ]
    then "${name} ${literalValueToString value}"
    else if vType == "null"
    then "${name} ${literalValueToString value}"
    else if vType == "set"
    then
      if value == {}
      then name
      else convertAttrsToKDL name value
    else if vType == "list"
    then convertListToKDL name value
    else
      throw ''
        Cannot convert type `(${typeOf value})` to KDL:
          ${name} = ${toString value}
      '';

  toKDL = attrs: ''
    ${concatStringsSep "\n" (mapAttrsToList convertAttributeToKDL attrs)}
  '';
in {
  generate = name: value:
    pkgs.writeText name (toKDL value);
}
