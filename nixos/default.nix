{ inputs
, outputs
, lib
, config
, pkgs
, username
, userdesc
, hostname
, ...
}: {
  imports = [
    ./hosts/${hostname}.nix
    ./hardware/${hostname}.nix
    ./impermanence/${hostname}.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.stable-packages
      outputs.overlays.unstable-packages
    ];
    config = {
      allowUnfree = true;
    };
  };

  # This will add each flake input as a registry
  # To make nix3 commands consistent with your flake
  nix.registry = (lib.mapAttrs (_: flake: { inherit flake; })) ((lib.filterAttrs (_: lib.isType "flake")) inputs);

  # This will additionally add your inputs to the system's legacy channels
  # Making legacy nix commands consistent as well, awesome!
  nix.nixPath = [ "/etc/nix/path" ];
  environment.etc =
    lib.mapAttrs'
      (name: value: {
        name = "nix/path/${name}";
        value.source = value.flake;
      })
      config.nix.registry // {
      issue = {
        text = ''
          \e{lightcyan}\S\e{reset} Login (\l)

        '';
      };
    };

  nix.settings = {
    # Enable flakes and new 'nix' command
    experimental-features = "nix-command flakes";
    # Deduplicate and optimize nix store
    auto-optimise-store = true;
    substituters = [
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
      "https://mirror.sjtu.edu.cn/nix-channels/store"
      "https://nix-community.cachix.org"
      "https://hyprland.cachix.org"
    ];
    trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
    trusted-users = [ "root" "${username}" ];
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-order-than 1w";
  };

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";
  networking.timeServers = [
    "0.cn.pool.ntp.org"
    "1.cn.pool.ntp.org"
    "2.cn.pool.ntp.org"
    "3.cn.pool.ntp.org"
  ];

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "zh_CN.UTF-8";
    LC_IDENTIFICATION = "zh_CN.UTF-8";
    LC_MEASUREMENT = "zh_CN.UTF-8";
    LC_MONETARY = "zh_CN.UTF-8";
    LC_NAME = "zh_CN.UTF-8";
    LC_NUMERIC = "zh_CN.UTF-8";
    LC_PAPER = "zh_CN.UTF-8";
    LC_TELEPHONE = "zh_CN.UTF-8";
    LC_TIME = "zh_CN.UTF-8";
  };
  networking.hostName = "${hostname}";

  security.sudo.extraRules = [
    {
      users = [ "${username}" ];
      commands = [
        {
          command = "ALL";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

  environment.systemPackages = with pkgs; [
    vim
    wget
    git

    file
    gnused
    gnutar
    gnupg

    zip
    unzip
    xz
    p7zip

    pciutils
    usbutils

    killall
  ];

  programs.zsh.enable = true;
  programs.dconf.enable = true;

  users = {
    users.${username} = {
      isNormalUser = true;
      description = "${userdesc}";
      shell = pkgs.zsh;
      extraGroups = [ "wheel" "imxyy" ];
    };
    groups.${username} = { };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
