{
  pkgs,
  inputs,
  lib,
  ...
}: let
  common = import ../_common {inherit lib;};
  inherit (common.lib) mkYamlFrontmatter memoryInstruction;
  inherit (common.commands) commandMeta commandNames readCommand;
  inherit (common.skills) skillMeta skillNames readSkill;
  inherit (common.agents) agentMeta agentNames readAgent;
  inherit (common.rules) ruleNames readRule;

  mkCommand = name: let
    meta = commandMeta.${name};
    body = readCommand name;
    frontmatter =
      {inherit (meta) description;}
      // lib.optionalAttrs (meta ? allowed-tools) {inherit (meta) allowed-tools;}
      // lib.optionalAttrs (meta ? argument-hint) {inherit (meta) argument-hint;};
  in
    mkYamlFrontmatter frontmatter + body;

  mkSkill = name: let
    meta = skillMeta.${name};
    body = readSkill name;
    frontmatter = {inherit (meta) name description;};
  in
    mkYamlFrontmatter frontmatter + body;

  mkAgent = name: let
    meta = agentMeta.${name};
    body = readAgent name;
    frontmatter = {
      inherit (meta) name description model;
      inherit (meta) tools;
    };
  in
    mkYamlFrontmatter frontmatter + body;

  ccstatusline = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.ccstatusline;

  wrappedClaude = pkgs.writeShellScriptBin "claude" ''
    set -euo pipefail

    export ANTHROPIC_BASE_URL="http://localhost:20128"
    export ANTHROPIC_AUTH_TOKEN="sk_omniroute"
    export ANTHROPIC_MODEL="auto"
    export CLAUDE_CODE_ENABLE_GATEWAY_MODEL_DISCOVERY="1"

    sudo systemctl start podman-omniroute
    trap 'sudo systemctl stop podman-omniroute' EXIT

    for _ in $(seq 1 120); do
      if curl -fsS http://localhost:20128/api/monitoring/health >/dev/null 2>&1; then
        break
      fi
      sleep 1
    done

    CLAUDE_JSON="$HOME/.claude.json"
    if [ -f "$CLAUDE_JSON" ]; then
      if ! ${pkgs.jq}/bin/jq -e 'has("hasCompletedOnboarding")' "$CLAUDE_JSON" >/dev/null 2>&1; then
        tmp="$CLAUDE_JSON.tmp"
        ${pkgs.jq}/bin/jq '. + {hasCompletedOnboarding: true}' "$CLAUDE_JSON" >"$tmp" \
          && chmod 600 "$tmp" \
          && mv "$tmp" "$CLAUDE_JSON"
      fi
    fi

    exec ${pkgs.claude-code}/bin/claude "$@"
  '';
in {
  programs.claude-code = {
    enable = true;
    package = wrappedClaude;

    commands = lib.genAttrs commandNames mkCommand;
    skills = lib.genAttrs skillNames mkSkill;
    agents = lib.genAttrs agentNames mkAgent;
    rules = lib.genAttrs ruleNames readRule;
    context = memoryInstruction;
    settings = {
      theme = "dark";
      renderMode = "fullscreen";
      outputStyle = "Default";
      statusLine = {
        command = "${ccstatusline}/bin/ccstatusline";
        padding = 0;
        type = "command";
      };

      env = {
        ANTHROPIC_BASE_URL = "http://localhost:20128";
        ANTHROPIC_AUTH_TOKEN = "sk_omniroute";
        ANTHROPIC_MODEL = "auto";
        CLAUDE_CODE_ENABLE_GATEWAY_MODEL_DISCOVERY = "1";
      };

      enableAllProjectMcpServers = true;
      voiceEnabled = true;
      skipDangerousModePermissionPrompt = true;
      claudeInChromeDefaultEnabled = false;
      attribution = {
        commit = "";
        pr = "";
      };

      outputStyles = import ./output-styles;
      permissions = import ./permissions.nix;
      enabledPlugins = import ./plugins.nix;
      hooks = import ./hooks.nix;
    };
  };

  home.packages = [ccstatusline];

  home.sessionVariables.DISABLE_AUTOUPDATER = "1";
}
