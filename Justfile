all: fmt switch

@live:
	./scripts/live-links.sh

@switch: live
	echo "Rebuilding NixOS..."
	nh os switch .

@switch-offline: live
	echo "Rebuilding NixOS without net..."
	nh os switch . --no-net

alias offline := switch-offline

@boot: live
	echo "Rebuilding NixOS..."
	nh os boot .

@test: live
	echo "Rebuilding NixOS..."
	nh os test .

@vm:
	echo "Building NixOS VM..."
	nh os build-vm .

@update:
	echo "Updating flakes..."
	nix flake update

@repl:
	nixos-rebuild repl --flake .

@cleandry:
	echo "Listing all generations older than 15 days..."
	sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --dry-run --older-than 15d
	nix profile wipe-history --profile ~/.local/state/nix/profiles/profile --dry-run --older-than 15d

@clean:
	echo "Removing all generations older than 15 days..."
	sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 15d
	nix profile wipe-history --profile ~/.local/state/nix/profiles/profile --older-than 15d

@gc:
	nix store gc --debug

@fmt:
	echo "Formatting files..."
	nix fmt

@sync-noctalia:
	echo "Folding noctalia GUI overrides back into the repo..."
	python3 scripts/sync-noctalia.py --apply

@sync-noctalia-preview:
	echo "Previewing noctalia config sync (no changes)..."
	python3 scripts/sync-noctalia.py
