{
  description = "imxyy_soope_'s NixOS (flake) config";

  inputs = {
    # Nixpkgs
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/release-25.05";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    # nixpkgs.follows = "nixpkgs-stable";
    nixpkgs.follows = "nixpkgs-unstable";
    # nixpkgs.follows = "nixpkgs-master";

    # Nyxpkgs
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    # TODO: sops-nix: remove pr patch once merged
    # https://github.com/Mic92/sops-nix/pull/779
    sops-nix = {
      url = "github:Mic92/sops-nix/pull/779/merge";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Impermanence
    impermanence.url = "github:nix-community/impermanence";

    # Niri
    niri.url = "github:sodiboo/niri-flake";

    darkly = {
      url = "github:Bali10050/Darkly";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # go-musicfox
    go-musicfox = {
      url = "github:imxyy1soope1/go-musicfox/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # NixOS-WSL
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen.url = "github:0xc000022070/zen-browser-flake";
    zen.inputs.nixpkgs.follows = "nixpkgs";

    quickshell = {
      url = "github:outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.quickshell.follows = "quickshell"; # Use same quickshell version
    };

    plant = {
      url = "git+ssh://git@git.imxyy.top:2222/imxyy1soope1/HF-plant.git?rev=08dc0b3889797eb3618c7475c3c367ec0e5fdf40";
      flake = false;
    };

    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    infuse = {
      url = "git+https://codeberg.org/amjoseph/infuse.nix";
      flake = false;
    };

    haumea = {
      url = "github:nix-community/haumea/v0.2.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      vars = import ./vars.nix;
      forAllSystems = lib.genAttrs lib.systems.flakeExposed;
      forAllHosts =
        mkSystem:
        lib.mergeAttrsList (
          builtins.map (hostname: {
            ${hostname} = mkSystem hostname;
          }) (builtins.attrNames (builtins.readDir ./config/hosts))
        );

      lib = (import ./lib/stdlib-extended.nix nixpkgs.lib).extend (
        final: prev: {
          inherit (inputs.home-manager.lib) hm;
          inherit infuse;
          haumea = inputs.haumea.lib;
        }
      );
      infuse = (import inputs.infuse { inherit (nixpkgs) lib; }).v1.infuse;
    in
    {
      packages = forAllSystems (
        system:
        lib.haumea.load {
          src = ./pkgs;
          loader = [
            {
              matches = str: builtins.match ".*\\.nix" str != null;
              loader = _: path: nixpkgs.legacyPackages.${system}.callPackage path { };
            }
          ];
          transformer = lib.haumea.transformers.liftDefault;
        }
      );

      # workaround for "treefmt warning"
      formatter = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        pkgs.writeShellApplication {
          name = "nixfmt-wrapper";

          runtimeInputs = with pkgs; [
            fd
            nixfmt-rfc-style
          ];

          text = ''
            fd "$@" -t f -e nix -x nixfmt '{}'
          '';
        }
      );

      overlays = import ./overlays {
        inherit inputs lib;
      };

      nixosConfigurations = forAllHosts (
        hostname:
        let
          overlays = builtins.attrValues self.overlays ++ [
            inputs.go-musicfox.overlays.default
            inputs.niri.overlays.niri
            inputs.fenix.overlays.default
            (final: prev: {
              darkly-qt5 = inputs.darkly.packages.${final.stdenv.hostPlatform.system}.darkly-qt5;
              darkly-qt6 = inputs.darkly.packages.${final.stdenv.hostPlatform.system}.darkly-qt6;

              noctalia-shell = inputs.noctalia.packages.${final.stdenv.hostPlatform.system}.default;
            })
            (final: prev: {
              inherit lib;
            })
          ];
          home = {
            home-manager = {
              sharedModules = [
                inputs.sops-nix.homeManagerModules.sops
                inputs.impermanence.nixosModules.home-manager.impermanence
                inputs.stylix.homeModules.stylix
                inputs.noctalia.homeModules.default
                inputs.zen.homeModules.beta
                # workaround for annoying stylix
                (
                  { lib, ... }:
                  {
                    nixpkgs.overlays = lib.mkForce null;
                  }
                )
              ];
              useGlobalPkgs = true;
            };
          };
          pkgsConf.nixpkgs = {
            inherit overlays;
            config.allowUnfree = true;
            flake.setNixPath = false;
          };
        in
        lib.nixosSystem {
          specialArgs = {
            inherit
              inputs
              outputs
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
                ./modules/desktop/wm/niri/waybar
              ];
              recursive = true;
            })
            ++ [
              (lib.mkAliasOptionModule [ "my" "hm" ] [ "home-manager" "users" vars.username ])
              ./config/base.nix
              ./config/hosts/${hostname}
              inputs.chaotic.nixosModules.default
              inputs.sops-nix.nixosModules.sops
              inputs.impermanence.nixosModules.impermanence
              inputs.home-manager.nixosModules.default
              inputs.niri.nixosModules.niri
              inputs.catppuccin.nixosModules.catppuccin
              home
              pkgsConf
            ];
        }
      );
    };
}
