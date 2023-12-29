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

    # OMZ
    omz.url = "github:imxyy1soope1/omz/master";
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
    , nixos-wsl
    , ...
    } @ inputs:
    let
      inherit (self) outputs;
      inherit (import ./constants.nix) username userfullname userdesc useremail hostprefix;
      systems = [
        "aarch64-linux"
        "i686-linux"
        "x86_64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
      hosts = [
        "${hostprefix}"
        "${hostprefix}-kvm"
        "${hostprefix}-wsl"
      ];
      forAllHosts = nixpkgs.lib.genAttrs hosts;
      forAllHomes = gen:
        nixpkgs.lib.attrsets.mergeAttrsList (
          builtins.map
            (
              hostname: { "${username}@${hostname}" = gen hostname; }
            )
            hosts
        );
    in
    {
      packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
      # Formatter for your nix files, available through 'nix fmt'
      # Other options beside 'alejandra' include 'nixpkgs-fmt'
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixpkgs-fmt);

      overlays = import ./overlays { inherit inputs; };
      nixosModules = import ./modules/nixos;
      homeManagerModules = import ./modules/home-manager;

      # Available through 'nixos-rebuild --flake .#your-hostname'
      nixosConfigurations = forAllHosts (
        hostname:
        nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs username userdesc hostname; };
          modules = [
            ./nixos/base.nix
          ];
        }
      );
      # Avaiable through 'home-manager switch --flake .#{username}.{hostname}'
      homeConfigurations = forAllHomes (
        hostname:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = { inherit inputs outputs username userfullname useremail hostname; };
          modules = [
            ./home-manager/home.nix
          ];
        }
      );
    };
}
