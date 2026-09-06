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
        inputs.fenix.overlays.default
        inputs.angrr.overlays.default
        inputs.llm-agents.overlays.shared-nixpkgs
        (
          final: prev:
          let
            system = final.stdenv.hostPlatform.system;
            getPkg = input: pkg: inputs.${input}.packages.${system}.${pkg};
          in
          {
            darkly-qt6 = getPkg "darkly" "darkly-qt6";

            noctalia-shell = inputs.noctalia.packages.${system}.default;

            nix-tree-rs = getPkg "nix-tree-rs" "default";
            fast-nix-gc = (getPkg "fast-nix-gc" "default").overrideAttrs {
              doCheck = false;
            };

            niri-unstable = (getPkg "niri" "niri").overrideAttrs {
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
