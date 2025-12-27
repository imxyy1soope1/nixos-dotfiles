{
  inputs,
  lib,
  config,
  pkgsParams,
  ...
}:
{
  _module.args = {
    pkgsParams = {
      overlays = builtins.attrValues config.flake.overlays ++ [
        inputs.go-musicfox.overlays.default
        inputs.niri.overlays.niri
        inputs.fenix.overlays.default
        inputs.angrr.overlays.default
        (final: prev: {
          darkly-qt5 = inputs.darkly.packages.${final.stdenv.hostPlatform.system}.darkly-qt5;
          darkly-qt6 = inputs.darkly.packages.${final.stdenv.hostPlatform.system}.darkly-qt6;

          noctalia-shell = inputs.noctalia.packages.${final.stdenv.hostPlatform.system}.default;
        })
      ];
      config.allowUnfree = true;
      flake.setNixPath = false;
    };
  };

  perSystem =
    {
      system,
      pkgs,
      ...
    }:
    {
      _module.args.pkgs = import inputs.nixpkgs (pkgsParams // { inherit system; });
      legacyPackages = pkgs;
      packages = lib.genAttrs (builtins.attrNames (config.flake.overlays.additions pkgs pkgs)) (
        pkg: pkgs.${pkg}
      );
    };

  flake.overlays.additions =
    final: prev:
    with lib.haumea;
    load {
      src = ../pkgs;
      loader = [
        {
          matches = str: builtins.match ".*\\.nix" str != null;
          loader = _: path: final.callPackage path { };
        }
      ];
      transformer = transformers.liftDefault;
    };
}
