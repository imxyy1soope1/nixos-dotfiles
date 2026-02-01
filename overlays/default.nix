{
  inputs,
  lib,
  ...
}:
let
  mkPkgs = type: final: _prev: {
    ${type} = import inputs."nixpkgs-${type}" {
      system = final.stdenv.hostPlatform.system;
      config.allowUnfree = true;
    };
  };
in
{
  flake.overlays = {
    modifications =
      final: prev:
      lib.infuse prev {
        cage.__output.patches.__append = [ ./cage-specify-output-name.patch ];
        bottles.__input.removeWarningPopup.__assign = true;

        easytier.__assign = final.stable.easytier;
      };
  }
  //
    # this allows us to access specific version of nixpkgs
    # by `pkgs.unstable`, `pkgs.stable` and `pkgs.master`
    lib.genAttrs [ "stable" "unstable" "master" ] mkPkgs;
}
