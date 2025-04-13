{
  description = "imxyy_soope_'s NixOS (flake) config";

  inputs = {
    # Nixpkgs
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable-small";
    nixpkgs-stable.url = "github:nixos/nixpkgs/release-24.11";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    # nixpkgs.follows = "nixpkgs-stable";
    nixpkgs.follows = "nixpkgs-unstable";

    # SOPS
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Impermanence
    impermanence.url = "github:nix-community/impermanence";

    # NUR
    nur.url = "github:nix-community/NUR";

    # NeoVim nightly
    # neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";
    # neovim-nightly.inputs.nixpkgs.follows = "nixpkgs";

    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

    # OMZ
    omz.url = "github:imxyy1soope1/omz/master";
    omz.inputs.nixpkgs.follows = "nixpkgs";

    # dwm
    dwm.url = "github:imxyy1soope1/dwm/master";
    dwm.inputs.nixpkgs.follows = "nixpkgs";

    # Niri
    niri.url = "github:sodiboo/niri-flake";
    niri.inputs.nixpkgs.follows = "nixpkgs";
    niri.inputs.nixpkgs-stable.follows = "nixpkgs-stable";

    quickshell.url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
    quickshell.inputs.nixpkgs.follows = "nixpkgs";

    darkly.url = "github:Bali10050/Darkly";
    darkly.inputs.nixpkgs.follows = "nixpkgs";

    stylix.url = "github:danth/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";

    # go-musicfox
    go-musicfox.url = "github:imxyy1soope1/go-musicfox/master";
    go-musicfox.inputs.nixpkgs.follows = "nixpkgs";

    # NixOS-WSL
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";

    fenix.url = "github:nix-community/fenix";
    fenix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixos-wsl,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      variables = import ./variables.nix;
      forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed;
      forAllHosts =
        gen:
        nixpkgs.lib.attrsets.mergeAttrsList (
          builtins.map (
            { hostname, ... }@host:
            {
              ${hostname} = gen host;
            }
          ) variables.hosts
        );
    in
    {
      packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
      formatter = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        pkgs.writeShellApplication {
          name = "nixfmt-wrapper";

          runtimeInputs = [
            pkgs.fd
            pkgs.nixfmt-rfc-style
          ];

          text = ''
            fd "$@" -t f -e nix -x nixfmt '{}'
          '';
        }
      );

      overlays = import ./overlays { inherit inputs; };

      # Available through 'nixos-rebuild --flake .#{hostname}'
      nixosConfigurations = forAllHosts (
        { hostname, system }:
        let
          lib = import ./lib/stdlib-extended.nix (
            nixpkgs.lib.extend (
              final: prev: {
                inherit (inputs.home-manager.lib) hm;
              }
            )
          );
          overlays = builtins.attrValues self.overlays ++ [
            inputs.go-musicfox.overlays.default
            inputs.omz.overlays.default
            inputs.dwm.overlays.default
            inputs.niri.overlays.niri
            # inputs.neovim-nightly.overlays.default
            inputs.fenix.overlays.default
            inputs.nix-vscode-extensions.overlays.default
            (final: prev: {
              darkly-qt5 = inputs.darkly.packages.${final.system}.darkly-qt5;
              darkly-qt6 = inputs.darkly.packages.${final.system}.darkly-qt6;
            })
            (final: prev: {
              quickshell = inputs.quickshell.packages.${final.system}.default.override {
                withJemalloc = true;
                withQtSvg = true;
                withWayland = true;
                withPipewire = false;
                withPam = false;
                withX11 = false;
                withHyprland = false;
              };
            })
          ];
          pkgs = import nixpkgs {
            inherit system overlays;
            config.allowUnfree = true;
          };
          specialArgs = {
            inherit (variables)
              username
              userdesc
              userfullname
              useremail
              ;

            inherit
              inputs
              outputs
              nixos-wsl
              system
              hostname
              ;

            sopsRoot = ./secrets;
          };
        in
        lib.nixosSystem {
          inherit specialArgs;
          modules = [
            ./modules
            ./config/base.nix
            ./config/hosts/${hostname}
            {
              nixpkgs = {
                inherit pkgs;
              };
            }

            inputs.sops-nix.nixosModules.sops
            inputs.impermanence.nixosModules.impermanence
            inputs.home-manager.nixosModules.default
            {
              home-manager = {
                sharedModules = [
                  inputs.sops-nix.homeManagerModules.sops
                  inputs.impermanence.nixosModules.home-manager.impermanence
                  inputs.stylix.homeManagerModules.stylix
                  inputs.niri.homeModules.niri
                  (
                    { lib, ... }:
                    {
                      nixpkgs.overlays = lib.mkForce null;
                    }
                  )
                ];
                useGlobalPkgs = true;
              };
            }
          ];
        }
      );
    };
}
