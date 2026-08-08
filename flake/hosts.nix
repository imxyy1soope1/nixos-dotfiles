{
  self,
  lib,
  inputs,
  config,
  pkgsParams,
  ...
}:
let
  vars = import ../vars.nix;
  pkgsModule = args: {
    nixpkgs = lib.mkMerge [
      pkgsParams
      {
        overlays = import ./overlays args;
      }
    ];
  };
  hmModule = {
    home-manager = {
      sharedModules = [
        # keep-sorted start
        inputs.niri-nix.homeModules.default
        inputs.noctalia.homeModules.default
        inputs.sops-nix.homeManagerModules.sops
        inputs.stylix.homeModules.stylix
        inputs.system76-scheduler-niri.homeModules.default
        inputs.zen.homeModules.beta
        # keep-sorted end
        {
          stylix.overlays.enable = lib.mkForce false;
        }
      ];
      useGlobalPkgs = true;
    };
  };
  upstreamModules = [
    # keep-sorted start
    inputs.angrr.nixosModules.angrr
    inputs.home-manager.nixosModules.default
    inputs.impermanence.nixosModules.impermanence
    inputs.niri-nix.nixosModules.default
    inputs.selector4nix.nixosModules.selector4nix
    inputs.sops-nix.nixosModules.sops
    # keep-sorted end
  ];
in
{
  options.nixosHosts = lib.mkOption {
    type = lib.types.attrsOf (
      lib.types.submodule (
        { name, ... }:
        {
          options = {
            system = lib.mkOption {
              type = lib.types.str;
              default = "x86_64-linux";
              description = "System architecture";
            };

            profiles = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              default = [ ];
              description = "List of profile names (e.g., 'desktop', 'server', 'wsl')";
            };

            modules = lib.mkOption {
              type = lib.types.listOf lib.types.deferredModule;
              default = lib.umport {
                paths = [ ../hosts/${name} ];
                extraExcludePredicate = path: lib.hasInfix "/_" (toString path);
                recursive = true;
              };
              description = "Additional NixOS modules specific to this host";
            };

            extraSpecialArgs = lib.mkOption {
              type = lib.types.attrs;
              default = { };
              description = "Extra special arguments to pass to modules";
            };
          };
        }
      )
    );
    default = { };
    description = "Declarative host definitions";
  };

  config = {
    # Generate nixosConfigurations from declarative host definitions
    flake.nixosConfigurations = lib.mapAttrs (
      hostname: hostConfig:
      lib.nixosSystem {
        inherit (hostConfig) system;

        specialArgs = {
          inherit
            inputs
            self
            hostname
            ;
          assets =
            with lib.haumea;
            load {
              src = ../assets;
              loader = [ (matchers.always loaders.path) ];
            };
          secrets =
            with lib.haumea;
            load {
              src = ../secrets;
              loader = [ (matchers.always loaders.path) ];
            };
        }
        // vars
        // hostConfig.extraSpecialArgs;

        modules =
          (lib.umport {
            paths = [ ../modules ];
            extraExcludePredicate = path: lib.hasInfix "/_" (toString path);
            recursive = true;
          })
          ++ [
            ../profiles/base.nix
          ]
          ++ (map (profile: ../profiles/${profile}.nix) hostConfig.profiles)
          ++ hostConfig.modules
          ++ upstreamModules
          ++ [
            (lib.mkAliasOptionModule [ "my" "hm" ] [ "home-manager" "users" vars.username ])

            # pkgs and home-manager configuration
            pkgsModule
            hmModule
          ];
      }
    ) config.nixosHosts;
  };
}
