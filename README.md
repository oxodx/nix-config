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
nixos-rebuild --target-host camelot --sudo switch --flake .#homelab-camelot
nixos-rebuild --target-host excalibur --sudo switch --flake .#homelab-excalibur
nixos-rebuild --target-host gawain --sudo switch --flake .#homelab-gawain
```

The homelab commands deliberately use the SSH aliases from
`home/services/terminal/software/ssh.nix`. The aliases select the matching
agenix-managed identity; using a raw IP bypasses that host-specific
`IdentityFile`. Remote activation uses `--sudo`, but the local command itself
must not be run with `sudo` or it will use root's SSH configuration.

Camelot's SSH address is distinct from its legacy media service address
(`192.168.1.47`). Preserve that distinction when editing network configuration.

### New homelab installation over SSH

First activate `.#oxod-laptop`. It decrypts the client identities into
`~/.ssh/homelab-{camelot,excalibur,gawain}` and installs the matching SSH
aliases. A newly imported NixOS container needs its public key bootstrapped
once before it can be managed remotely. From the corresponding Proxmox node's
root shell, substitute the container ID, host name and public-key file:

```bash
# Run on the laptop to display the public key. Public keys are not secrets.
cat ~/.ssh/homelab-excalibur.pub

# Run on the Proxmox node. Replace CTID and PUBLIC_KEY.
pct exec CTID -- /run/current-system/sw/bin/install -d -m 700 -o oxod -g users /home/oxod/.ssh
pct exec CTID -- sh -c 'echo "PUBLIC_KEY" >> /home/oxod/.ssh/authorized_keys'
pct exec CTID -- /run/current-system/sw/bin/chown oxod:users /home/oxod/.ssh/authorized_keys
pct exec CTID -- /run/current-system/sw/bin/chmod 600 /home/oxod/.ssh/authorized_keys
```

Confirm the new server's SSH host-key fingerprint through the Proxmox console,
connect once to record it, then verify non-interactive key authentication:

```bash
ssh excalibur
ssh -o BatchMode=yes excalibur true
```

Deploy from the repository as the normal laptop user:

```bash
nixos-rebuild --target-host excalibur --sudo switch --flake .#homelab-excalibur
```

Use the equivalent `camelot`/`homelab-camelot` or
`gawain`/`homelab-gawain` pair for the other containers. After the first
successful activation, NixOS manages `oxod`'s authorized key declaratively.

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
| `oxod-laptop` | laptop | Hyprland, Quickshell, development and games |
| `tv` | desktop | Plasma Bigscreen |
| `homelab-camelot` | server | Media services |
| `homelab-excalibur` | server | Pelican and container management |
| `homelab-gawain` | server | DNS, reverse proxy and dashboard |

### Forgejo and Pages

Gawain serves Forgejo at `https://git.oxod.nl` with PostgreSQL, Git LFS and a
Docker-backed Actions runner. Forgejo only listens on loopback. A single
remotely managed homelab Cloudflare Tunnel connects to Caddy's loopback-only
port `8082`; Caddy allow-lists each public hostname and routes it to its local
service. The router needs no inbound port forwarding, and the origin address is
not exposed in public DNS.

Create a remotely managed tunnel in Cloudflare Zero Trust, copy its connector
token, then store the token with agenix (the file must contain only the token):

```bash
cd secrets
agenix -e cloudflare-tunnel-token.age -i ~/.ssh/id_ed25519
git add cloudflare-tunnel-token.age
```

In the tunnel's **Published application routes**, add `*.oxod.nl` with service
type `HTTP` and URL `127.0.0.1:8082`. The wildcard makes this the shared homelab
tunnel, while Caddy's port-8082 allow-list decides which hostnames actually
exist. Cloudflare preserves the requested hostname for Caddy to match. Do not
add an A/AAAA record for `git.oxod.nl`, add it to home DNS, or forward ports
80/443. Additional public services only need an explicit Caddy route; unmatched
hostnames receive a 404 response.

Gawain also runs [git-pages](https://codeberg.org/git-pages/git-pages), the
server behind Codeberg Pages. Static sites are public at
`https://pages.oxod.nl/REPOSITORY/`; the `oxod/oxod.nl` portfolio is built and
published by Forgejo Actions at `https://pages.oxod.nl/`. Like Forgejo, Pages
is only reachable through the tunnel and Caddy allow-list.

The short project URL defaults to the `oxod` owner. Other Forgejo users publish
at `https://pages.oxod.nl/USER/REPOSITORY/`. An owner-aware local router treats
the first path component as an owner only when it matches an existing Forgejo
user, so nested assets under `oxod` project sites keep working normally.

To publish static files, enable Actions for the repository and add
`.forgejo/workflows/pages.yml` (replace the repository name and build
command/output directory):

```yaml
name: Deploy Pages

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Build
        run: npm ci && npm run build
      - uses: https://codeberg.org/git-pages/action@v2
        with:
          site: https://pages.oxod.nl/REPOSITORY/
          server: pages.oxod.nl
          token: ${{ forge.token }}
          source: dist/
```

No deployment secret is required: Forgejo supplies a short-lived workflow
token, and git-pages verifies that it has push access to the matching
repository. The `oxod/oxod.nl` workflow uses `https://pages.oxod.nl/` for
`site`; repositories owned by other users use
`https://pages.oxod.nl/USER/REPOSITORY/`.

The `oxod.home` namespace remains house-DNS-only. AdGuard resolves those names
on the LAN, Caddy serves them with its internal CA on the normal HTTP/HTTPS
listeners, and none of them are included in the tunnel ingress allow-list.

Registration is deliberately disabled. After the first deployment, create the
administrator locally so its password never enters this repository or the Nix
store:

```bash
ssh gawain
sudo -u forgejo forgejo --config /var/lib/forgejo/custom/conf/app.ini \
  admin user create --admin --username oxod --email me@oxod.nl --random-password
```

Save the one-time password in a password manager, sign in, and change it. HTTPS
clones and pushes then use `https://git.oxod.nl/OWNER/REPOSITORY.git`; use a
Forgejo access token as the Git password and store it in an OS credential
helper. The Actions registration token is generated into `/run` during boot,
and Forgejo's signing/session secrets and runner identity remain in root- or
service-only state directories. They are never evaluated by Nix or committed.

Only enable Actions for trusted repositories and workflows: Docker-backed CI
jobs effectively have control of the runner node. Back up `/var/lib/forgejo`,
the PostgreSQL database, `/var/lib/gitea-runner`, and `/var/lib/git-pages`
together.

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

Eden's Switch keys are encrypted in `secrets/eden-{prod,title}-keys.age` for
the laptop and TV. Agenix installs them with mode `0600` in
`~/.config/eden/keys`, the launcher's default key directory.

---

## Packages

`packages.<system>` exports buildable packages supported on that system.
The parameterized web-app builder is `lib.mkWebApp pkgs { name = ...; url = ...; }`.

---

## Credits

- [**ryan4yin/nix-config**](https://github.com/ryan4yin/nix-config)
- [**linuxmobile/shin**](https://github.com/linuxmobile/shin)
- [**nix-media-server/nixarr**](https://github.com/nix-media-server/nixarr)

---

<p align="center">
  <a href="https://github.com/oxodx/nix-config/graphs/contributors">Contributors</a> &bull;
  <a href="LICENSE">MIT License</a>
</p>
