{
  inputs,
  self,
  config,
  lib,
  pkgs,
  secrets,
  username,
  ...
}:
let
  cfg = config.my.nix;
in
{
  options.my.nix = {
    enable = lib.mkEnableOption "default nix settings";
  };

  config = lib.mkIf cfg.enable {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    nix.registry = (lib.mapAttrs (_: flake: { inherit flake; })) (
      ((lib.filterAttrs (_: lib.isType "flake")) inputs) // { flake = self; }
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
      experimental-features = "nix-command flakes pipe-operators";
      substituters = [
        "https://mirrors.sjtug.sjtu.edu.cn/nix-channels/store"
        "https://mirror.sjtu.edu.cn/nix-channels/store"
        "https://mirrors.ustc.edu.cn/nix-channels/store"
        "https://nix-community.cachix.org"
        "https://cache.garnix.io"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      ];
      download-buffer-size = 536870912; # 512 MiB
    };

    sops.secrets.nix-github-token = {
      sopsFile = secrets.nix-github-token;
      format = "binary";
      owner = username;
      group = "users";
      mode = "0400";
    };

    my.hm = {
      nix.extraOptions = ''
        !include ${config.sops.secrets.nix-github-token.path}
      '';

      home.packages = with pkgs; [
        nixd
        nixfmt
      ];

      xdg.configFile."direnv/lib/angrr.sh".source =
        "${config.services.angrr.package}/share/direnv/lib/angrr.sh";

      programs.direnv.stdlib = ''
        use angrr
      '';
    };

    # uncomment to enable auto gc
    /*
      nix.gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 30d";
      };
    */

    services.angrr = {
      enable = true;
      settings = {
        period = "1month";
      };
    };
  };
}
