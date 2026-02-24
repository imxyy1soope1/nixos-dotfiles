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

    environment.etc =
      (lib.mapAttrs' (name: value: {
        name = "nix/path/${name}";
        value.source = value.flake;
      }) config.nix.registry)
      // {
        "nix/nix-racer.toml".source = (pkgs.formats.toml { }).generate "nix-racer.toml" {
          listen = "127.0.0.1:2048";
          substituters = [
            {
              penalty = 0;
              url = "https://mirror.sjtu.edu.cn/nix-channels/store";
            }
            {
              penalty = 50;
              url = "https://mirrors.ustc.edu.cn/nix-channels/store";
            }
            {
              penalty = 0;
              url = "https://nix-community.cachix.org";
            }
            {
              penalty = 0;
              url = "https://cache.garnix.io";
            }
            {
              penalty = 100;
              url = "https://cache.nixos.org";
            }
          ];
        };
      };

    systemd.services.nix-racer = {
      description = "Nix substituter proxy with parallel cache queries and latency-aware selection";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];

      serviceConfig = {
        Type = "simple";
        ExecStart = "${lib.getExe (pkgs.callPackage ./nix-racer/_package.nix { })}";
        Restart = "on-failure";
        RestartSec = 5;

        DynamicUser = true;
        CapabilityBoundingSet = [ "" ];
        DeviceAllow = "";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateTmp = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectSystem = "strict";
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@resources"
          "~@privileged"
        ];
        UMask = "0077";
      };
    };

    nix.settings = {
      experimental-features = "nix-command flakes pipe-operators";
      substituters = lib.mkForce [
        "http://127.0.0.1:2048"

        # "https://mirrors.ustc.edu.cn/nix-channels/store"
        # "https://mirrors.sjtug.sjtu.edu.cn/nix-channels/store"
        # "https://mirror.sjtu.edu.cn/nix-channels/store"
        # "https://nix-community.cachix.org"
        # "https://cache.garnix.io"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
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
