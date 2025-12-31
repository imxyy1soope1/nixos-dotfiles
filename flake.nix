{
  description = "imxyy_soope_'s NixOS (flake) config";

  inputs = {
    # Nixpkgs
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/release-25.11";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    # nixpkgs.follows = "nixpkgs-stable";
    nixpkgs.follows = "nixpkgs-unstable";
    # nixpkgs.follows = "nixpkgs-master";

    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # NixOS-WSL
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Flake organization tools
    # keep-sorted start block=yes
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    haumea = {
      url = "github:nix-community/haumea/v0.2.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    infuse = {
      url = "git+https://codeberg.org/amjoseph/infuse.nix";
      flake = false;
    };
    # keep-sorted end

    # Useful modules
    # keep-sorted start block=yes
    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence.url = "github:nix-community/impermanence";
    # TODO: sops-nix: remove pr patch once merged
    # https://github.com/Mic92/sops-nix/pull/779
    sops-nix = {
      url = "github:Mic92/sops-nix/pull/779/merge";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # keep-sorted end

    # Useful software
    # keep-sorted start block=yes
    angrr = {
      url = "github:linyinfeng/angrr";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    darkly = {
      url = "github:Bali10050/Darkly";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    go-musicfox = {
      url = "github:imxyy1soope1/go-musicfox";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri.url = "github:sodiboo/niri-flake";
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell/v3.8.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen.inputs.nixpkgs.follows = "nixpkgs";
    zen.url = "github:0xc000022070/zen-browser-flake";
    # keep-sorted end

    # Misc
    treefmt = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plant = {
      url = "git+ssh://git@git.imxyy.top:2222/imxyy1soope1/HF-plant.git?rev=08dc0b3889797eb3618c7475c3c367ec0e5fdf40";
      flake = false;
    };
    my-templates.url = "git+https://git.imxyy.top/imxyy1soope1/flake-templates";
  };

  outputs =
    {
      flake-parts,
      ...
    }@inputs:
    flake-parts.lib.mkFlake
      {
        inherit inputs;
        specialArgs.lib = import ./lib {
          inherit (inputs.nixpkgs) lib;
          inherit inputs;
        };
      }
      {
        systems = [ "x86_64-linux" ];

        imports = [
          ./flake/hosts.nix
          ./flake/pkgs.nix
          ./treefmt.nix
          ./overlays
        ];

        nixosHosts = {
          imxyy-nix = {
            profiles = [ "desktop" ];
          };

          imxyy-nix-server = {
            profiles = [ "server" ];
          };

          imxyy-nix-wsl = {
            profiles = [ "wsl" ];
            modules = [
              inputs.nixos-wsl.nixosModules.default
            ];
          };

          imxyy-nix-x16 = {
            profiles = [ "desktop" ];
          };
        };
      };
}
