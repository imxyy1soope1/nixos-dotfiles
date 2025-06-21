# Just a convenience function that returns the given Nixpkgs standard
# library extended with the imxyy library.

stdlib:

let
  mkMyLib = import ./.;
in
stdlib.extend (
  self: super: {
    my = mkMyLib { lib = self; };
    umport = import ./umport.nix { lib = self; };
  }
)
