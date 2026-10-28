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

## Quick Start

```bash
sudo nixos-rebuild switch --flake .#oxod-laptop
sudo nixos-rebuild --target-host trouble@192.168.1.237 --sudo switch --flake .#tv
sudo nixos-rebuild --target-host oxod@192.168.1.185 --sudo switch --flake .#homelab-camelot
sudo nixos-rebuild --target-host oxod@192.168.1.206 --sudo switch --flake .#homelab-excalibur
sudo nixos-rebuild --target-host oxod@192.168.1.41 --sudo switch --flake .#homelab-gawain
```

---

## Secrets

Secrets are managed with agenix. The development shell includes its CLI.

To edit or rekey the Git SSH identity, run:

```bash
nix develop
cd secrets
agenix -e git.age
```

Recipients are declared in `secrets/secrets.nix`. Keep private keys only in the
encrypted `.age` files; public keys may be committed normally.

`secrets/default.nix` is the central registry. It exposes a `secrets` argument
to every NixOS module, so a module can accept `{ secrets, ... }` and use paths
such as `secrets.ssh.git.path` or `secrets.ssh.git.publicKey`.

---

## Credits

- [**ryan4yin/nix-config**](https://github.com/ryan4yin/nix-config)
- [**nix-media-server/nixarr**](https://github.com/nix-media-server/nixarr)

---

<p align="center">
  <a href="https://github.com/oxodx/nix-config/graphs/contributors">Contributors</a> &bull;
  <a href="LICENSE">MIT License</a>
</p>
