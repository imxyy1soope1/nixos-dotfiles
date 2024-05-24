{
  description = "imxyy_soope_'s NixOS (flake) config";

  inputs = {
    # Nixpkgs
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs.follows = "nixpkgs-unstable";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Impermanence
    impermanence.url = "github:nix-community/impermanence";

    # NUR
    nur.url = "github:nix-community/NUR";

    # fenix (rust overlay)
    fenix.url = "github:nix-community/fenix";
    fenix.inputs.nixpkgs.follows = "nixpkgs";

    # NeoVim nightly
    neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";
    neovim-nightly.inputs.nixpkgs.follows = "nixpkgs";

    # OMZ
    omz.url = "github:imxyy1soope1/omz/master";
    omz.inputs.nixpkgs.follows = "nixpkgs";

    # dwm
    dwm.url = "github:imxyy1soope1/dwm/master";
    dwm.inputs.nixpkgs.follows = "nixpkgs";

    # Hyprland
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    hyprland.inputs.nixpkgs.follows = "nixpkgs";
    hyprland-contrib.url = "github:hyprwm/contrib/main";
    hyprland-contrib.inputs.nixpkgs.follows = "nixpkgs";

    # go-musicfox
    go-musicfox.url = "github:imxyy1soope1/go-musicfox/master";
    go-musicfox.inputs.nixpkgs.follows = "nixpkgs";

    # hyprsome
    hyprsome.url = "github:sopa0/hyprsome/master";
    hyprsome.inputs.nixpkgs.follows = "nixpkgs";

    # NixOS-WSL
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    { self
    , nixpkgs
    , home-manager
    , impermanence
    , nixos-wsl
    , ...
    } @ inputs:
    let
      inherit (self) outputs;
      variables = import ./variables.nix;
      forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed;
      forAllHosts = gen:
        nixpkgs.lib.attrsets.mergeAttrsList (
          builtins.map
            (
              { hostname, ... }@host: { ${hostname} = gen host; }
            )
            variables.hosts
        );
      overlay = {
        nixpkgs.overlays = builtins.attrValues self.overlays ++ [
          inputs.fenix.overlays.default
          inputs.omz.overlays.default
          inputs.dwm.overlays.default
          inputs.hyprland-contrib.overlays.default
          inputs.go-musicfox.overlays.default
          inputs.neovim-nightly.overlays.default
        ];
      };
    in
    {
      packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixpkgs-fmt);

      overlays = import ./overlays { inherit inputs; };
      nixosModules = import ./modules/nixos;
      homeManagerModules = import ./modules/home-manager;

      # Available through 'nixos-rebuild --flake .#{hostname}'
      nixosConfigurations = forAllHosts (
        { hostname, system }:
        let
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
              impermanence
              system
              hostname
              ;
          };
        in
        nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          modules = (nixpkgs.lib.attrValues (import ./modules/nixos)) ++ [
            overlay
            ./nixos
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                sharedModules = nixpkgs.lib.attrValues (import ./modules/home-manager) ++ [ overlay ];
                useUserPackages = true;
                users.${variables.username} = import ./home;
                extraSpecialArgs = specialArgs;
              };
            }
          ];
        }
      );
    };
}
