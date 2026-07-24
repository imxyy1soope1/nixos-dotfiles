{
  inputs,
  lib,
  config,
  ...
}:
[
  (
    final: prev:
    lib.infuse prev {
      cage.__output.patches.__append = [ ./cage-specify-output-name.patch ];
      bottles.__input.removeWarningPopup.__assign = true;

      easytier.__assign = final.stable.easytier;

      angrr.__output.patches.__append = [
        (import <nix/fetchurl.nix> {
          url = "https://github.com/linyinfeng/angrr/pull/54.patch";
          hash = "sha256-esJq0SkQkmpC/GWdcQJ9fTiHd67CG7z0iRIaZNYZyAc=";
        })
      ];
    }
  )
  (final: _prev: {
    stable = import inputs.nixpkgs-stable {
      inherit (final.stdenv.hostPlatform) system;
      inherit (config.nixpkgs) config;
    };
    master = import inputs.nixpkgs-master {
      inherit (final.stdenv.hostPlatform) system;
      inherit (config.nixpkgs) config;
    };
  })
]
