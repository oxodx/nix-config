# AGENTS.md - Guidelines for AI Coding Agents

This file defines the default operating guide for AI agents working in this Nix Flake repository.
Keep changes minimal, verifiable, and safe for multi-host deployment.

## Scope and Repository model

This repository manages:

- NixOS hosts (desktop + servers)
- Home Manager profiles shared across platforms
- Remote deployments via colmena

High-level layout:

```text
.
├── flake.nix                    # Flake entry; outputs composed in ./outputs
├── Taskfile.yml                 # Primary command entrypoint
├── outputs/
│   ├── default.nix
│   └── x86_64-linux/
├── modules/                     # NixOS modules
├── home/                        # Home Manager modules
├── hosts/                       # Host-specific config
└── lib/                         # Helper functions
```


## Ground Rules for Agents

- Prefer `task` tasks over ad-hoc commands when an equivalent task exists.
- Make the smallest reasonable change; avoid drive-by refactors.
- Do not commit secrets, generated credentials, or private keys.
- Run formatting and evaluation checks for touched areas before finishing.

## Quick Start Workflow (Recommended)

1. Inspect context:

```bash
task --list
rg -n "<symbol-or-option>" modules home hosts outputs
```

2. Implement the change.
3. Format:

```bash
task fmt
```

4. Validate:

```bash
task test
```

5. If deployment behavior changed, provide the exact `task` command the user should run (do not run
   remote deploys unless explicitly requested).

## Canonical Commands

### Core quality loop

```bash
task fmt                    # format Nix files
task test                   # run eval tests: nix eval .#evalTests ...
task flake-check            # run flake checks + pre-commit style checks
```

### Dependency/input updates

```bash
task up                     # update all inputs and commit lock file
task upp <input>            # update one input and commit lock file
task up-nix                 # update nixpkgs-related inputs
```

### Local deploy commands

```bash
task nixos-switch:local                  # deploy config for current hostname
task nixos-switch:local:debug            # same with verbose/debug mode
task nixos-switch:local:niri             # deploy "<hostname>-niri" on Linux
task nixos-switch:local:niri:debug       # debug mode
```

### Remote deploy commands (colmena)

```bash
task col <tag>              # deploy nodes matching tag
task lab                    # deploy all kubevirt nodes
task k3s                    # deploy k3s nodes
```

### Useful direct commands

```bash
nix eval .#evalTests --show-trace --print-build-logs --verbose
nix build .#nixosConfigurations.<host>.config.system.build.toplevel
nixos-rebuild switch --flake .#<hostname>
```

## Test Structure and Expectations

Eval tests live under:

- `outputs/x86_64-linux/tests/`

Typical test pair:

- `expr.nix`
- `expected.nix`

Agent expectations:

- If logic changes affect shared modules, run `task test`.
- If only docs/comments changed, tests may be skipped, but say so explicitly.
- If tests cannot run, report why and include the exact failing command.

## Formatting and Style

### Formatting tools

- Nix: `nixfmt` (RFC style, width 100)
- Non-Nix: `prettier` (see `.prettierrc.yaml`)
- Spelling: `typos` (see `.typos.toml`)

### Nix style conventions

- Files use `kebab-case.nix`.
- Prefer `inherit (...)` for attribute imports.
- Prefer `lib.mkIf`, `lib.optional`, `lib.optionals` for conditional config.
- Use `lib.mkDefault` for defaults and `lib.mkForce` only when necessary.
- Keep module options documented with `description`.

Module pattern:

```nix
{ lib, config, ... }:
{
  options.myFeature = {
    enable = lib.mkEnableOption "my feature";
  };

  config = lib.mkIf config.myFeature.enable {
    # ...
  };
}
```

## Secrets and Safety

- Secrets are managed with agenix and an external private secrets repo.
- Never inline secret values in Nix files, tests, or docs.
- Do not run broad remote deploy commands unless requested.
- Prefer build/eval validation first, deploy second.

## Change Review Checklist (for agents)

Before finishing, verify:

1. Change is scoped to requested behavior.
2. `task fmt` applied (or not needed, stated explicitly).
3. `task test` run for config changes (or limitation explained).
4. No secrets or machine-specific artifacts added.
5. User-facing summary includes what changed and what was validated.

## Common Pitfalls

- Editing host-specific files when the change belongs in shared module layers (`modules/` or
  `home/`).
- Forgetting to update both Linux and darwin paths when touching shared abstractions.
- Running deployment commands to validate syntax when `nix eval`/`nix build` would be safer.
- Introducing hardcoded usernames/paths instead of using `myvars` and existing abstractions.

## References

- [README.md](./README.md)
- [Taskfile](./Taskfile.yml)
