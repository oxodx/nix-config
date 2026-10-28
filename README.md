<div align="center">
  <h1> [ nix-config ] </h1>
</div>

<p align="center">
  <b>oxod's nixos configuration.</b>
</p>

<p align="center">
  <img src="https://img.shields.io/github/last-commit/oxodx/nix-config?&style=for-the-badge&color=8ad7eb&logo=git&logoColor=D9E0EE&labelColor=1E202B" />
  <img src="https://img.shields.io/github/stars/oxodx/nix-config?&style=for-the-badge&color=8ad7eb&logo=git&logoColor=D9E0EE&labelColor=1E202B" />
  <img src="https://img.shields.io/github/repo-size/oxodx/nix-config?&style=for-the-badge&color=8ad7eb&logo=git&logoColor=D9E0EE&labelColor=1E202B" />
</p>

---

Personal NixOS configurations for a laptop, a TV, and three Proxmox homelab nodes.
Pinned flake inputs, shared module profiles, and agenix-managed SSH identities.

## Quick Start

```bash
sudo nixos-rebuild switch --flake .#oxod-laptop
sudo nixos-rebuild --target-host trouble@192.168.1.237 --sudo switch --flake .#tv
sudo nixos-rebuild --target-host oxod@192.168.1.185 --sudo switch --flake .#homelab-camelot
sudo nixos-rebuild --target-host oxod@192.168.1.206 --sudo switch --flake .#homelab-excalibur
sudo nixos-rebuild --target-host oxod@192.168.1.41 --sudo switch --flake .#homelab-gawain
```

Camelot's SSH address above is distinct from its legacy media service address
(`192.168.1.47`). Preserve that distinction when editing network configuration.

---

## Layout

```text
flake.nix       Inputs, packages, development shells, and formatter
hosts/          Host entry points, hardware, and host-specific services
profiles/       Shared base, desktop, laptop, and server compositions
system/         Reusable NixOS modules grouped by responsibility
home/           oxod's applications, dotfiles, and desktop configuration
secrets/        Encrypted keys, recipient rules, and secret registry
pkgs/           Custom package definitions and web-app builder
lib/            Reusable Nix functions
assets/         Shared images and public certificates
```

Each host imports a profile and its own additional modules. Profiles compose
ordinary NixOS modules. Directories that enable all their modules use
`mylib.scanPaths ./.`, which imports child directories and Nix files except
`default.nix`. Adding a module there enables it automatically.

Profiles and directories containing optional modules keep explicit `imports`
lists. Shared root-level assets use `mylib.relativeToRoot "assets/..."`.
Both helpers are available through the `mylib` module argument.

The `home/` directory contains **NixOS modules**, not Home Manager modules.
`home/xdgCompat.nix` provides the existing `home.file` and `xdg.configFile`
interfaces. Keep application settings and their supporting assets together.

---

## Hosts

| Flake name | Profile | Purpose |
| --- | --- | --- |
| `oxod-laptop` | laptop | Niri, Quickshell, development and games |
| `tv` | desktop | Plasma Bigscreen |
| `homelab-camelot` | server | Media services |
| `homelab-excalibur` | server | Pelican and container management |
| `homelab-gawain` | server | DNS, reverse proxy and dashboard |

Hardware details and `system.stateVersion` belong to the host. Do not change
`stateVersion` as part of a routine input update.

---

## Development

```bash
nix develop
nix fmt
nix flake check --no-build --all-systems
```

Git flakes only include tracked files. After adding a module or encrypted secret,
stage it before evaluating the normal flake. To validate unstaged new files:

```bash
nix flake check --no-build --all-systems path:.
```

Update a dependency explicitly, then validate and build before switching:

```bash
nix flake update nixpkgs
nixos-rebuild build --flake .#oxod-laptop
sudo nixos-rebuild switch --flake .#oxod-laptop
```

---

## Secrets

`secrets/default.nix` declares identities, their destinations, and which hosts
receive them. Modules can reference the registry directly:

```nix
{secrets, ...}: {
  example.identityFile = secrets.ssh.camelot.path;
}
```

These values are runtime paths, not decrypted contents. Never read a private key
into a Nix expression or put plaintext secrets in the Nix store.

`secrets/secrets.nix` defines encryption recipients. The laptop receives the
homelab client keys; the laptop and TV receive the Git identity. Each homelab
node authorizes its corresponding public key for `oxod`.

```bash
nix develop
cd secrets
agenix -e git.age -i ~/.ssh/git
# After changing recipients:
agenix -r -i ~/.ssh/git
```

Keep a recovery copy of the admin identity and each machine's SSH host identity.
The host identity is needed to decrypt secrets during activation.

---

## Packages

`packages.<system>` exports buildable packages supported on that system.
The parameterized web-app builder is `lib.mkWebApp pkgs { name = ...; url = ...; }`.

---

## Credits

- [**ryan4yin/nix-config**](https://github.com/ryan4yin/nix-config)
- [**nix-media-server/nixarr**](https://github.com/nix-media-server/nixarr)

---

<p align="center">
  <a href="https://github.com/oxodx/nix-config/graphs/contributors">Contributors</a> &bull;
  <a href="LICENSE">MIT License</a>
</p>
