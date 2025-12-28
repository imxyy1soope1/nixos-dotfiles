{ lib, inputs }:
lib.extend (
  self: super: {
    inherit (inputs.home-manager.lib) hm;
    umport = import ./umport.nix { lib = self; };
    haumea = inputs.haumea.lib;
    infuse = (import inputs.infuse { inherit lib; }).v1.infuse;
  }
)
