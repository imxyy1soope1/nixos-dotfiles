set export

IMPURE_ROOT := `pwd`

all: fmt switch

@switch:
	echo "Rebuilding NixOS..."
	nh os switch . --impure

@switch-offline:
	echo "Rebuilding NixOS without net..."
	nh os switch . --impure --no-net

alias offline := switch-offline

@boot:
	echo "Rebuilding NixOS..."
	nh os boot . --impure

@test:
	echo "Rebuilding NixOS..."
	nh os test . --impure

@vm:
	echo "Building NixOS VM..."
	nh os build-vm . --impure

@update:
	echo "Updating flakes..."
	nix flake update

@repl:
	nixos-rebuild repl --flake .

@cleandry:
	echo "Listing all generations older than 15 days..."
	sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --dry-run --older-than 15d
	nix profile wipe-history --profile ~/.local/state/nix/profiles/home-manager --dry-run --older-than 15d

@clean:
	echo "Removing all generations older than 15 days..."
	sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 15d
	nix profile wipe-history --profile ~/.local/state/nix/profiles/home-manager --older-than 15d

@gc:
	nix store gc --debug

@fmt:
	echo "Formatting files..."
	nix fmt
