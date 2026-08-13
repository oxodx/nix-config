{lib}: let
  inherit (import ../lib.nix {inherit lib;}) readRule;

  ruleNames = ["git-workflow" "security" "documentation" "code-quality"];

  combinedRules = lib.concatStringsSep "\n\n---\n\n" (map readRule ruleNames);
in {
  inherit
    ruleNames
    readRule
    combinedRules
    ;
}
