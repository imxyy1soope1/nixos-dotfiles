{
  inputs,
  lib,
  config,
  ...
}:
{
  perSystem =
    { system, pkgs, ... }:
    {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
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

      legacyPackages = pkgs;

      packages = lib.genAttrs (builtins.attrNames (config.flake.overlays.additions pkgs pkgs)) (
        pkg: pkgs.${pkg}
      );
    };

  flake.overlays.additions =
    final: prev:
    let
      paths = [
        ./fcitx5-lightly
        ./mono-gtk-theme.nix
        ./ttf-wps-fonts.nix
        ./wps-office-fonts.nix
      ];
    in
    builtins.listToAttrs (
      map (path: {
        name = builtins.elemAt (lib.splitString "." (builtins.baseNameOf path)) 0;
        value = final.callPackage path { };
      }) paths
    );
}
