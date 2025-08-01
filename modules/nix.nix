{
  inputs,
  config,
  lib,
  pkgs,
  secrets,
  username,
  ...
}:
lib.my.makeSwitch {
  inherit config;
  default = true;
  optionName = "default nix settings";
  optionPath = [ "nix" ];
  config' = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    nix.registry = (lib.mapAttrs (_: flake: { inherit flake; })) (
      (lib.filterAttrs (_: lib.isType "flake")) inputs
    );

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nix.nixPath = [ "/etc/nix/path" ];

    environment.systemPackages = with pkgs; [
      nix-output-monitor
      nh
    ];

    environment.etc = lib.mapAttrs' (name: value: {
      name = "nix/path/${name}";
      value.source = value.flake;
    }) config.nix.registry;

    nix.settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Deduplicate and optimize nix store
      auto-optimise-store = true;
      substituters = [
        "https://mirrors.sjtug.sjtu.edu.cn/nix-channels/store"
        "https://mirror.sjtu.edu.cn/nix-channels/store"
        "https://mirrors.ustc.edu.cn/nix-channels/store"
        "https://nix-community.cachix.org"
        "https://cache.nixos.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };

    sops.secrets.nix-github-token = {
      sopsFile = secrets.nix-github-token;
      format = "binary";
      owner = username;
      group = "users";
      mode = "0400";
    };
    my.home.nix.extraOptions = ''
      !include ${config.sops.secrets.nix-github-token.path}
    '';

    # uncomment to enable auto gc
    /*
      nix.gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 30d";
      };
    */
  };
}
