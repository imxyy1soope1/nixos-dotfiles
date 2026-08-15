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
        inputs.niri-nix.overlays.niri-nix
        inputs.fenix.overlays.default
        inputs.angrr.overlays.default
        inputs.llm-agents.overlays.shared-nixpkgs
        (
          final: prev:
          let
            system = final.stdenv.hostPlatform.system;
          in
          {
            darkly-qt6 = inputs.darkly.packages.${system}.darkly-qt6;

            noctalia-shell = inputs.noctalia.packages.${system}.default;

            nix-tree-rs = inputs.nix-tree-rs.packages.${system}.default;
            fast-nix-gc = inputs.fast-nix-gc.packages.${system}.default.overrideAttrs {
              doCheck = false;
            };
          }
        )
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
