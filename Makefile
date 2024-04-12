all: fmt os

os:
	@echo "Rebuilding NixOS..."
	@nixos-rebuild switch --flake . --use-remote-sudo

vm:
	@echo "Building NixOS VM..."
	@nixos-rebuild build-vm --flake .

update:
	@echo "Updating flakes..."
	@nix flake update

update-hyprland:
	@echo "Updating Hyprland flake..."
	@nix flake lock --update-input hyprland

history:
	@nix profile history --profile /nix/var/nix/profiles/system

replpkgs:
	@nix repl -f flake:nixpkgs

repl:
	@nix repl .

cleandry:
	@echo "Listing all generations older than 15 days..."
	@sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --dry-run --older-than 15d
	@nix run home-manager#home-manager -- expire-generations -15days --dry-run

clean:
	@echo "Removing all generations older than 15 days..."
	@sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 15d
	@nix run home-manager#home-manager -- expire-generations -15days

gc:
	@nix store gc --debug

fmt:
	@echo "Formatting nix files..."
	@nix fmt

.PHONY: os home news update history repl clean gc fmt
