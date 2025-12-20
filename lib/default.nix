{ lib, inputs }:
lib.extend (
  self: super: {
    my = import ./my.nix { lib = self; };
    umport = import ./umport.nix { lib = self; };
    inherit (inputs.home-manager.lib) hm;
    haumea = inputs.haumea.lib;
    infuse = (import inputs.infuse { inherit lib; }).v1.infuse;
  }
)
