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

        python314Packages.patool.__input.file.__output.postPatch.__append =
          lib.warn "Remove `file` patch once https://github.com/NixOS/nixpkgs/pull/540742 is merged" ''
            substituteInPlace src/landlock.c --replace-fail \
              "LANDLOCK_ACCESS_FS_READ_FILE | LANDLOCK_ACCESS_FS_READ_DIR" \
              "LANDLOCK_ACCESS_FS_READ_FILE | LANDLOCK_ACCESS_FS_READ_DIR | LANDLOCK_ACCESS_FS_EXECUTE"
          '';
      };
  }
  //
    # this allows us to access specific version of nixpkgs
    # by `pkgs.unstable`, `pkgs.stable` and `pkgs.master`
    lib.genAttrs [ "stable" "unstable" "master" ] mkPkgs;
}
