os:
	nixos-rebuild switch --flake . --use-remote-sudo

home:
	home-manager switch --flake .

news:
	home-manager news --flake .

update:
	nix flake update

history:
	nix profile history --profile /nix/var/nix/profiles/system

repl:
	nix repl -f flake:nixpkgs

clean:
	# remove all generations older than 7 days
	sudo nix profile wipe-history --profile /nix/var/nix/profiles/system  --older-than 7d
	home-manager expire-generations -7days

gc:
	nix store gc --debug

fmt:
	nix fmt

.PHONY: os home news update history repl clean gc fmt
