<h2 align="center">:snowflake: imxyy_soope_'s NixOS Config :snowflake:</h2>

> This configuration and READMEs in this repo borrows heavily from [ryan4yin/nix-config](https://github.com/ryan4yin/nix-config) and his 
> [cookbook](https://github.com/ryan4yin/nixos-and-flakes-book). Many thanks to his spirit of sharing!

This repository is home to the nix code that builds my systems:
Currently, this repository contains the nix code that builds:

1. NixOS Desktop (`imxyy-nix`): NixOS with home-manager, niri, neovim, etc.
2. NixOS Laptop (`imxyy-nix-x16`): the desktop profile on a laptop
3. NixOS home server (`imxyy-nix-server`)
4. NixOS WSL (`imxyy-nix-wsl`)

See [./hosts](./hosts) for details of each host.

## Why NixOS & Flakes?

Nix allows for easy-to-manage, collaborative, reproducible deployments. This
means that once something is setup and configured once, it works (almost)
forever. If someone else shares their configuration, anyone else can just use it
(if you really understand what you're copying/refering now).

As for Flakes, refer to
[Introduction to Flakes - NixOS & Nix Flakes Book](https://nixos-and-flakes.thiscute.world/nixos-with-flakes/introduction-to-flakes)

This configuration uses [flake-parts](https://flake.parts/) for better flake organization and modularity,
enabling declarative host definitions and cleaner separation of concerns.

## Folder Structure

- `modules/` - custom NixOS modules, auto-imported via `lib.umport`
  - `modules/core/` - core system modules (nix, persistence, time, user, xdg)
  - `modules/cli/` - command-line tools and utilities
  - `modules/coding/` - development environments and editors
  - `modules/desktop/` - desktop applications and window managers
  - `modules/virt/` - virtualization configurations
  - `modules/i18n/` - locale and input method (fcitx5)
  - `modules/programs/` - misc system programs (e.g. ollama)
  - `modules/*.nix` - standalone modules (audio, bluetooth, fonts, gpg, sops, etc.)
- `profiles/` - system configuration profiles
  - `profiles/base.nix` - base configuration for all hosts
  - `profiles/desktop.nix` - desktop environment configuration
  - `profiles/server.nix` - server-specific configuration
  - `profiles/wsl.nix` - WSL-specific configuration
- `hosts/<name>/` - host-specific configs
- `flake/` - flake-parts modules
  - `flake/hosts.nix` - declarative host definitions
  - `flake/pkgs.nix` - custom packages exported from the flake
  - `flake/overlays/` - nixpkgs overlays and patches
- `lib/` - custom nix library
- `pkgs/` - custom packages
- `vars.nix` - my variables
- `secrets/` - secrets managed by sops-nix. see [./secrets](./secrets) for details
- `flake.nix` - flake entry
