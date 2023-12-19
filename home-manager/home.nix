# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    ./programs
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
      inputs.omz.overlays.default
      inputs.hyprland.overlays.default
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "imxyy";
    homeDirectory = "/home/imxyy";
  };

  # Add stuff for your user as you see fit:
  home.packages = with pkgs; [
    lsd
    neofetch
    fzf
    bat
    ripgrep

    zip
    unzip
    xz

    aria2
    socat

    file
    gnused
    gnutar
    gnupg

    nix-output-monitor

    btop
    htop

    pciutils
    usbutils

    omz
  ];

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    userName = "imxyy_soope_";
    userEmail = "3516554684@qq.com";
  };

  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    history = {
      size = 20000;
      save = 20000;
    };
    initExtraFirst = "source ${pkgs.omz}/share/omz/omz.zsh";
    shellAliases = {
      ls = "lsd";
      cat = "bat";
      svim = "sudoedit";
      nf = "neofetch";
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
