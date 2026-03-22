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

See [./hosts](./hosts) for details of each host.

## Why NixOS & Flakes?

Nix allows for easy-to-manage, collaborative, reproducible deployments. This means that once
something is setup and configured once, it works (almost) forever. If someone else shares their
configuration, anyone else can just use it (if you really understand what you're copying/referring
now).

As for Flakes, refer to
[Introduction to Flakes - NixOS & Nix Flakes Book](https://nixos-and-flakes.thiscute.world/nixos-with-flakes/introduction-to-flakes)

## Components

|                                                                | NixOS(Wayland)                                                                           |
| -------------------------------------------------------------- | ---------------------------------------------------------------------------------------- |
| **Window Manager**                                             | [Niri][Niri]                                                                             |
| **Terminal Emulator**                                          | [Zellij][Zellij] + [foot][foot]/[Kitty][Kitty]/[Alacritty][Alacritty]/[Ghostty][Ghostty] |
| **Status Bar** / **Notifier** / **Launcher** / **lockscreens** | [noctalia-shell][noctalia-shell]                                                         |
| **Display Manager**                                            | [tuigreet][tuigreet]                                                                     |
| **Color Scheme**                                               | [catppuccin-nix][catppuccin-nix]                                                         |
| **network management tool**                                    | [NetworkManager][NetworkManager]                                                         |
| **System resource monitor**                                    | [Btop][Btop]                                                                             |
| **File Manager**                                               | [Yazi][Yazi] + [thunar][thunar]                                                          |
| **Shell**                                                      | [Nushell][Nushell] + [Starship][Starship]                                                |
| **Media Player**                                               | [mpv][mpv]                                                                               |
| **Text Editor**                                                | [Neovim][Neovim]                                                                         |
| **Fonts**                                                      | [Nerd fonts][Nerd fonts]                                                                 |
| **Image Viewer**                                               | [imv][imv]                                                                               |
| **Screenshot Software**                                        | Niri's builtin function                                                                  |
| **Screen Recording**                                           | [OBS][OBS]                                                                               |
