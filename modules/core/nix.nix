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
      nix-tree-rs
      fast-nix-gc
    ];

    environment.etc = (
      lib.mapAttrs' (name: value: {
        name = "nix/path/${name}";
        value.source = value.flake;
      }) config.nix.registry
    );

    services.selector4nix = {
      enable = true;
      configureSubstituter = "keep";
      settings = {
        server.port = 5496;
        substituters = map (subst: if builtins.isString subst then { url = subst; } else subst) [
          "https://mirror.sjtu.edu.cn/nix-channels/store"
          "https://mirrors.sjtug.sjtu.edu.cn/nix-channels/store"
          "https://mirrors.ustc.edu.cn/nix-channels/store"
          "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
          "https://nix-community.cachix.org"
          "https://selector4nix.cachix.org/"
          "https://cache.numtide.com"
          "https://cache.nixos.org"
        ];
      };
    };

    nix.settings = {
      experimental-features = "nix-command flakes pipe-operators";
      substituters = lib.mkForce [
        "http://127.0.0.1:${toString (config.services.selector4nix.settings.server.port or 5496)}"
        "https://cache.nixos.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "selector4nix.cachix.org-1:wovVlT07In5JCVz2tFgxPQTLpnN8hZT6P/RwfFcz3KE="
        "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
      ];
      download-buffer-size = 536870912; # 512 MiB
      warn-dirty = false;
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
        temporary-root-policies = {
          direnv = {
            path-regex = "/\\.direnv/";
            period = "14d";
          };
          result = {
            path-regex = "/result[^/]*$";
            period = "3d";
          };
        };
        profile-policies = {
          system = {
            profile-paths = [ "/nix/var/nix/profiles/system" ];
            keep-since = "14d";
            keep-latest-n = 5;
            keep-booted-system = true;
            keep-current-system = true;
          };
          user = {
            profile-paths = [
              "~/.local/state/nix/profiles/profile"
              "/nix/var/nix/profiles/per-user/root/profile"
            ];
            keep-since = "14d";
            keep-latest-n = 5;
          };
        };
      };
    };
  };
}
