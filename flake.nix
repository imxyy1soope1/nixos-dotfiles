{
  description = "imxyy_soope_'s NixOS (flake) config";

  inputs = rec {
    # Nixpkgs
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs = nixpkgs-unstable;

    # Home manager
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # OMZ
    omz.url = "github:imxyy1soope1/omz/master";
    # omz.url = "/home/imxyy/omz";

    # dwm
    dwm.url = "github:imxyy1soope1/dwm/master";
    # dwm.url = "/home/imxyy/dwm";
    dwm.inputs.nixpkgs.follows = "nixpkgs";

    # Hyprland
    hyprland.url = "github:hyprwm/Hyprland/main";
    hyprland.inputs.nixpkgs.follows = "nixpkgs";

    # go-musicfox
    go-musicfox.url = "github:imxyy1soope1/go-musicfox/master";
    go-musicfox.inputs.nixpkgs.follows = "nixpkgs";

    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";

    # hardware.url = "github:nixos/nixos-hardware";

    # Shameless plug: looking for a way to nixify your themes and make
    # everything match nicely? Try nix-colors!
    # nix-colors.url = "github:misterio77/nix-colors";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-stable,
    home-manager,
    nixos-wsl,
    ...
  } @ inputs: let
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
    homes = [
      "${username}@${hostprefix}"
      "${username}@${hostprefix}-kvm"
      "${username}@${hostprefix}-wsl"
    ];
    forAllHomes = nixpkgs.lib.genAttrs homes;
  in {
    # Your custom packages
    # Accessible through 'nix build', 'nix shell', etc
    packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
    # Formatter for your nix files, available through 'nix fmt'
    # Other options beside 'alejandra' include 'nixpkgs-fmt'
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    # Your custom packages and modifications, exported as overlays
    overlays = import ./overlays {inherit inputs;};
    # Reusable nixos modules you might want to export
    # These are usually stuff you would upstream into nixpkgs
    nixosModules = import ./modules/nixos;
    # Reusable home-manager modules you might want to export
    # These are usually stuff you would upstream into home-manager
    homeManagerModules = import ./modules/home-manager;

    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = forAllHosts (
      hostname:
        nixpkgs.lib.nixosSystem {
          specialArgs = {inherit inputs outputs username userdesc hostname;};
          modules = [
            # > Our main nixos configuration file <
            ./nixos/base.nix
          ];
        }
    );
    # Standalone home-manager configuration entrypoint
    homeConfigurations."${username}" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
      extraSpecialArgs = {inherit inputs outputs username userfullname useremail;};
      modules = [
        # > Our main home-manager configuration file <
        ./home-manager/home.nix
      ];
    };
  };
}
