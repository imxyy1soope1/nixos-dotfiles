<h2 align="center">:snowflake: imxyy_soope_'s NixOS Config :snowflake:</h2>

> This configuration and READMEs in this repo borrows heavily from [ryan4yin/nix-config](https://github.com/ryan4yin/nix-config) and his 
> [cookbook](https://github.com/ryan4yin/nixos-and-flakes-book). Many thanks to his spirit of sharing!

This repository is home to the nix code that builds my systems:
Currently, this repository contains the nix code that builds:

1. NixOS Desktop: NixOS with home-manager, niri, neovim, etc.
2. NixOS home server
3. NixOS WSL

See [./config/hosts](./config/hosts) for details of each host.

## Why NixOS & Flakes?

Nix allows for easy-to-manage, collaborative, reproducible deployments. This
means that once something is setup and configured once, it works (almost)
forever. If someone else shares their configuration, anyone else can just use it
(if you really understand what you're copying/refering now).

As for Flakes, refer to
[Introduction to Flakes - NixOS & Nix Flakes Book](https://nixos-and-flakes.thiscute.world/nixos-with-flakes/introduction-to-flakes)

## Components

|                               | NixOS(Wayland)                                          |
| ----------------------------- | :------------------------------------------------------ |
| **Window Manager**            | Niri                                                    |
| **Terminal Emulator**         | Alacritty & Kitty & Foot & Ghostty                      |
| **Bar**                       | Waybar                                                  |
| **Application Launcher**      | wofi                                                    |
| **Notification Daemon**       | SwayNotificationCenter                                  |
| **Input method framework**    | Fcitx5                                                  |
| **Shell**                     | Zsh                                                     |
| **Netease Cloudmusic Player** | go-musicfox                                             |
| **Media Player**              | mpv                                                     |
| **Text Editor**               | Neovim                                                  |
| **Fonts**                     | Noto Sans CJK & Jetbrains Mono & Nerd Font              |
| **Filesystem**                | btrfs subvolumes, clean '/' every boot for impermanence |

And more...

## Folder Structure

- `modules/` - custom NixOS modules
- `config/base.nix` - generic configs
- `config/hosts/<name>/` - hosts-specific configs
- `lib/` - custom nix library
- `pkgs/` - custom packages
- `overlays/` - nixpkgs overlays
- `vars.nix` - my variables
- `secrets/` - secrets managed by sops-nix. see [./secrets](./secrets) for details
- `flake.nix` - flake entry
