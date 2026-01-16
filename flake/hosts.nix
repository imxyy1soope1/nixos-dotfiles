{
  self,
  lib,
  inputs,
  withSystem,
  config,
  pkgsParams,
  ...
}:
let
  vars = import ../vars.nix;
  pkgsModule = {
    nixpkgs = pkgsParams;
  };
  hmModule = {
    home-manager = {
      sharedModules = [
        # keep-sorted start
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
              default = (
                lib.umport {
                  paths = [ ../hosts/${name} ];
                  extraExcludePredicate = path: lib.hasInfix "/_" (toString path);
                  recursive = true;
                }
              );
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
      withSystem hostConfig.system (
        { ... }:
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
            # Automatically import all feature modules
            (lib.umport {
              paths = [ ../modules ];
              extraExcludePredicate = path: lib.hasInfix "/_" (toString path);
              recursive = true;
            })
            ++ [
              # Base profile (always included)
              ../profiles/base.nix
            ]
            # Add requested profiles
            ++ (map (profile: ../profiles/${profile}.nix) hostConfig.profiles)
            # Add host-specific modules
            ++ hostConfig.modules
            ++ [
              (lib.mkAliasOptionModule [ "my" "hm" ] [ "home-manager" "users" vars.username ])

              # Upstream modules
              # keep-sorted start
              inputs.angrr.nixosModules.angrr
              inputs.catppuccin.nixosModules.catppuccin
              inputs.home-manager.nixosModules.default
              inputs.impermanence.nixosModules.impermanence
              inputs.niri.nixosModules.niri
              inputs.sops-nix.nixosModules.sops
              # keep-sorted end

              # pkgs and home-manager configuration
              pkgsModule
              hmModule
            ];
        }
      )
    ) config.nixosHosts;
  };
}
