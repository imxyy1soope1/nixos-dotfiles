{
  self,
  lib,
  inputs,
  pkgsParams,
  ...
}:
let
  forAllHosts =
    mkSystem:
    lib.mergeAttrsList (
      builtins.map (hostname: {
        ${hostname} = mkSystem hostname;
      }) (builtins.attrNames (builtins.readDir ./config/hosts))
    );
  pkgsModule =
    { config, ... }:
    {
      nixpkgs = pkgsParams // {
        inherit (config.nixpkgs.hostPlatform) system;
      };
    };
  hmModule = {
    home-manager = {
      sharedModules = [
        inputs.sops-nix.homeManagerModules.sops
        inputs.impermanence.nixosModules.home-manager.impermanence
        inputs.stylix.homeModules.stylix
        inputs.noctalia.homeModules.default
        inputs.zen.homeModules.beta

        {
          nixpkgs = lib.mkForce { };
        }
      ];
      useGlobalPkgs = true;
    };
  };
  vars = import ./vars.nix;
in
{
  flake.nixosConfigurations = forAllHosts (
    hostname:
    lib.nixosSystem {
      specialArgs = {
        inherit
          inputs
          self
          hostname
          ;
        assets =
          with lib.haumea;
          load {
            src = ./assets;
            loader = [
              (matchers.always loaders.path)
            ];
          };
        secrets =
          with lib.haumea;
          load {
            src = ./secrets;
            loader = [
              (matchers.always loaders.path)
            ];
          };
      }
      // vars;
      modules =
        (lib.umport {
          paths = [ ./modules ];
          exclude = [
            ./modules/virt/types
          ];
          recursive = true;
        })
        ++ (lib.umport {
          paths = [ ./config/hosts/${hostname} ];
          recursive = true;
        })
        ++ [
          (lib.mkAliasOptionModule [ "my" "hm" ] [ "home-manager" "users" vars.username ])
          ./config/base.nix
          inputs.sops-nix.nixosModules.sops
          inputs.impermanence.nixosModules.impermanence
          inputs.home-manager.nixosModules.default
          inputs.niri.nixosModules.niri
          inputs.catppuccin.nixosModules.catppuccin
          inputs.angrr.nixosModules.angrr
          pkgsModule
          hmModule
        ];
    }
  );
}
