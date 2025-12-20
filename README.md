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

This configuration uses [flake-parts](https://flake.parts/) for better flake organization and modularity,
enabling declarative host definitions and cleaner separation of concerns.

## Components

|                               | NixOS(Wayland)                               |
| ----------------------------- | :------------------------------------------- |
| **Window Manager**            | Niri                                         |
| **Desktop Shell**             | Noctalia Shell                               |
| **Terminal Emulator**         | Kitty                                        |
| **Input method framework**    | Fcitx5                                       |
| **Shell**                     | Zsh                                          |
| **Netease Cloudmusic Player** | go-musicfox                                  |
| **Media Player**              | mpv                                          |
| **Text Editor**               | Neovim                                       |
| **Fonts**                     | Noto Sans CJK & Jetbrains Mono & Nerd Font   |
| **Filesystem**                | Btrfs                                        |

And more...

## Folder Structure

- `modules/` - custom NixOS modules
  - `modules/core/` - core system modules (nix, persistence, time, user, xdg)
  - `modules/cli/` - command-line tools and utilities
  - `modules/coding/` - development environments and editors
  - `modules/desktop/` - desktop applications and window managers
  - `modules/virt/` - virtualization configurations
- `profiles/` - system configuration profiles
  - `profiles/base.nix` - base configuration for all hosts
  - `profiles/desktop.nix` - desktop environment configuration
  - `profiles/server.nix` - server-specific configuration
  - `profiles/wsl.nix` - WSL-specific configuration
- `config/hosts/<name>/` - host-specific configs
- `flake/` - flake-parts modules
  - `flake/hosts.nix` - declarative host definitions
- `lib/` - custom nix library
- `pkgs/` - custom packages
- `overlays/` - nixpkgs overlays
- `vars.nix` - my variables
- `secrets/` - secrets managed by sops-nix. see [./secrets](./secrets) for details
- `flake.nix` - flake entry