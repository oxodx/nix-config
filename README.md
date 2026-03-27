<h2 align="center">:snowflake: 0x0D's Nix Config :snowflake:</h2>

<p align="center">
  <img src="https://raw.githubusercontent.com/catppuccin/catppuccin/main/assets/palette/macchiato.png" width="400" />
</p>

<p align="center">
	<a href="https://github.com/0x0Dx/nix-config/stargazers">
		<img alt="Stargazers" src="https://img.shields.io/github/stars/0x0Dx/nix-config?style=for-the-badge&logo=starship&color=C9CBFF&logoColor=D9E0EE&labelColor=302D41"></a>
    <a href="https://nixos.org/">
        <img src="https://img.shields.io/badge/NixOS-25.11-informational.svg?style=for-the-badge&logo=nixos&color=F2CDCD&logoColor=D9E0EE&labelColor=302D41"></a>
  </a>
</p>

This repository is home to the nix code that builds my systems:

1. NixOS Desktops: NixOS with home-manager, niri, agenix, etc.
2. NixOS Servers: virtual machines running on Proxmox/KubeVirt, with various services, such as
   kubernetes, homepage, prometheus, grafana, etc.

See [./hosts](./hosts) for details of each host.

## Why NixOS & Flakes?

Nix allows for easy-to-manage, collaborative, reproducible deployments. This means that once
something is setup and configured once, it works (almost) forever. If someone else shares their
configuration, anyone else can just use it (if you really understand what you're copying/referring
now).

As for Flakes, refer to
[Introduction to Flakes - NixOS & Nix Flakes Book](https://nixos-and-flakes.thiscute.world/nixos-with-flakes/introduction-to-flakes)

## Components

|                                                                | NixOS(Wayland)                                                                                                                                                                                                                             |
| -------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **Window Manager**                                             | [Niri](https://github.com/niri-wm/niri)                                                                                                                                                                                                    |
| **Terminal Emulator**                                          | [Zellij](https://github.com/zellij-org/zellij) + [foot](https://codeberg.org/dnkl/foot)/[Kitty](https://github.com/kovidgoyal/kitty)/[Alacritty](https://github.com/alacritty/alacritty)/[Ghostty](https://github.com/ghostty-org/ghostty) |
| **Status Bar** / **Notifier** / **Launcher** / **lockscreens** | [noctalia-shell](https://github.com/noctalia-dev/noctalia-shell)                                                                                                                                                                           |
| **Display Manager**                                            | [tuigreet](https://github.com/apognu/tuigreet)                                                                                                                                                                                             |
| **Color Scheme**                                               | [catppuccin-nix](https://github.com/catppuccin/nix)                                                                                                                                                                                        |
| **network management tool**                                    | [NetworkManager](https://wiki.gnome.org/Projects/NetworkManager)                                                                                                                                                                           |
| **System resource monitor**                                    | [Btop](https://github.com/aristocratos/btop)                                                                                                                                                                                               |
| **File Manager**                                               | [Yazi](https://github.com/sxyazi/yazi) + [thunar](https://gitlab.xfce.org/xfce/thunar)                                                                                                                                                     |
| **Shell**                                                      | [Zsh](https://www.zsh.org/) + [Starship](https://github.com/starship/starship)                                                                                                                                                             |
| **Media Player**                                               | [mpv](https://github.com/mpv-player/mpv)                                                                                                                                                                                                   |
| **Text Editor**                                                | [Neovim](https://github.com/neovim/neovim)                                                                                                                                                                                                 |
| **Fonts**                                                      | [Nerd fonts](https://github.com/ryanoasis/nerd-fonts)                                                                                                                                                                                      |
| **Image Viewer**                                               | [imv](https://sr.ht/~exec64/imv/)                                                                                                                                                                                                          |
| **Screenshot Software**                                        | Niri's builtin function                                                                                                                                                                                                                    |
| **Screen Recording**                                           | [OBS](https://obsproject.com/)                                                                                                                                                                                                             |

## Agents

See [./agents](./agents) for my reusable cross-project agent files and installer script.

## How to Deploy this Flake?

<!-- prettier-ignore -->
> :red_circle: **IMPORTANT**: **You should NOT deploy this flake directly on your machine :exclamation:
> It will not succeed.** This flake contains my hardware configuration(such as
> [hardware-configuration.nix](hosts/kumquat/hardware-configuration.nix),
> etc.) which is not suitable for your hardware, and requires my private secrets repository
> [0x0Dx/nix-secrets](https://github.com/0x0Dx/nix-config/tree/main/secrets) to deploy. You
> may use this repo as a reference to build your own configuration.

For NixOS:

```bash
# deploy one of the configuration based on the hostname
sudo nixos-rebuild switch --flake .#kumquat-niri

# Deploy the niri nixosConfiguration by hostname match
task nixos-switch:local:niri

# or we can deploy with details
task nixos-switch:local:niri:debug
```

## References

Other dotfiles that inspired me:

- Nix Flakes
  - [ryan4yin/nix-config](https://github.com/ryan4yin/nix-config)
  - [wimpysworld/nix-config](https://github.com/wimpysworld/nix-config)
