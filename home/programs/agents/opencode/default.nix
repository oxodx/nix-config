{
  lib,
  pkgs,
  inputs,
  ...
}: let
  common = import ../_common {inherit lib;};
  inherit (common.lib) memoryInstruction;
  inherit (common.rules) combinedRules;
in {
  programs.opencode = {
    enable = true;
    package = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.opencode;
    enableMcpIntegration = true;

    tui = {
      keybinds.leader = "ctrl+x";
      scroll_speed = 3;
      scroll_acceleration.enabled = true;
      diff_style = "auto";
    };

    context = memoryInstruction + "\n\n" + combinedRules;
    settings = {
      autoupdate = false;
      autoshare = false;

      lsp = import ./lsp.nix;
      plugin = import ./plugins.nix;
      formatter = import ./formatters.nix;
    };
  };
}
