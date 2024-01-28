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

history:
	@nix profile history --profile /nix/var/nix/profiles/system

replpkgs:
	@nix repl -f flake:nixpkgs

repl:
	@nix repl .

clean:
	@echo "Removing all generations older than 7 days..."
	@sudo nix profile wipe-history --profile /nix/var/nix/profiles/system  --older-than 7d
	@nix run home-manager#default -- expire-generations -7days

gc:
	@nix store gc --debug

fmt:
	@echo "Formatting nix files..."
	@nix fmt

.PHONY: os home news update history repl clean gc fmt
