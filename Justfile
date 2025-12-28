root := `pwd`
NH := "IMPURE_ROOT=" + root + " nh"

all: fmt switch

switch:
	@echo "Rebuilding NixOS..."
	@{{NH}} os switch . --impure

switch-offline:
	@echo "Rebuilding NixOS without net..."
	@{{NH}} os switch . --impure --no-net

alias offline := switch-offline

boot:
	@echo "Rebuilding NixOS..."
	@{{NH}} os boot . --impure

test:
	@echo "Rebuilding NixOS..."
	@{{NH}} os test . --impure

vm:
	@echo "Building NixOS VM..."
	@{{NH}} os build-vm . --impure

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
