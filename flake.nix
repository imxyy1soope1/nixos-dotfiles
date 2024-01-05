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

    # OMZ
    omz.url = "github:imxyy1soope1/omz/master";
    omz.inputs.nixpkgs.follows = "nixpkgs";
    # omz.url = "/home/imxyy/omz";

    # dwm
    dwm.url = "github:imxyy1soope1/dwm/master";
    dwm.inputs.nixpkgs.follows = "nixpkgs";
    #dwm-local.url = "/home/imxyy/dwm";
    dwm-local.url = "github:imxyy1soope1/dwm/master";
    dwm-local.inputs.nixpkgs.follows = "nixpkgs";

    # Hyprland
    hyprland.url = "github:hyprwm/Hyprland/main";
    hyprland.inputs.nixpkgs.follows = "nixpkgs";

    # go-musicfox
    go-musicfox.url = "github:imxyy1soope1/go-musicfox/master";
    go-musicfox.inputs.nixpkgs.follows = "nixpkgs";

    # NixOS-WSL
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    { self
    , nixpkgs
    , nixpkgs-stable
    , home-manager
    , impermanence
    , nixos-wsl
    , ...
    } @ inputs:
      with import ./constants.nix // import ./variables.nix;
      let
        inherit (self) outputs;
        forAllSystems = nixpkgs.lib.genAttrs systems;
        forAllHosts = nixpkgs.lib.genAttrs hosts;
      in
      {
        packages = forAllSystems (system: nixpkgs.legacyPackages.${system});
        # Formatter for your nix files, available through 'nix fmt'
        # Other options beside 'alejandra' include 'nixpkgs-fmt'
        formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixpkgs-fmt);

        overlays = import ./overlays { inherit inputs; };
        nixosModules = import ./modules/nixos;
        homeManagerModules = import ./modules/home-manager;

        # Available through 'nixos-rebuild --flake .#{hostname}'
        nixosConfigurations = forAllHosts (
          hostname:
          nixpkgs.lib.nixosSystem {
            specialArgs = { inherit inputs outputs nixos-wsl impermanence username userdesc hostname; };
            modules = (nixpkgs.lib.attrValues (import ./modules/nixos)) ++ [
              ./nixos
              home-manager.nixosModules.home-manager
              {
                home-manager.users.${username} = import ./home;
                home-manager.extraSpecialArgs = { inherit inputs outputs username userfullname useremail hostname; };
              }
            ];
          }
        );
      };
}
