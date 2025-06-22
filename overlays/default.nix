{ inputs, infuse, ... }:
{
  additions = final: prev: import ../pkgs prev;

  modifications =
    final: prev:
    infuse prev {
      cage.__output.patches.__append = [ ./cage-specify-output-name.patch ];
      matrix-synapse.__assign = final.stable.matrix-synapse;
    };

  # this allows us to access specific version of nixpkgs
  # by `pkgs.unstable`, `pkgs.stable` and `pkgs.master`
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config.allowUnfree = true;
    };
  };

  stable-packages = final: _prev: {
    stable = import inputs.nixpkgs-stable {
      system = final.system;
      config.allowUnfree = true;
    };
  };

  master-packages = final: _prev: {
    master = import inputs.nixpkgs-master {
      system = final.system;
      config.allowUnfree = true;
    };
  };

  nur-packages = inputs.nur.overlays.default;
}
