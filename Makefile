all: fmt switch

switch:
	@echo "Rebuilding NixOS..."
	@nh os switch .

switch-offline:
	@echo "Rebuilding NixOS without net..."
	@nh os switch . --no-net

boot:
	@echo "Rebuilding NixOS..."
	@nh os boot .

test:
	@echo "Rebuilding NixOS..."
	@nh os test .

vm:
	@echo "Building NixOS VM..."
	@nh os build-vm .

update:
	@echo "Updating flakes..."
	@nix flake update

repl:
	@nixos-rebuild repl --flake .

cleandry:
	@echo "Listing all generations older than 15 days..."
	@sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --dry-run --older-than 15d
	@nix profile wipe-history --profile ~/.local/state/nix/profiles/home-manager --dry-run --older-than 15d

clean:
	@echo "Removing all generations older than 15 days..."
	@sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 15d
	@nix profile wipe-history --profile ~/.local/state/nix/profiles/home-manager --older-than 15d

gc:
	@nix store gc --debug

fmt:
	@echo "Formatting nix files..."
	@nix fmt

.PHONY: all switch switch-offline boot test vm update repl cleandry clean gc fmt
