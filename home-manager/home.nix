# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{ inputs
, outputs
, pkgs
, lib
, username
, userfullname
, useremail
, hostname
, ...
}: {
  # You can import other home-manager modules here
  imports = [
    ./hosts/${hostname}.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
      inputs.omz.overlays.default
      inputs.dwm.overlays.default
      inputs.hyprland.overlays.default
      inputs.go-musicfox.overlays.default
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
    username = "${username}";
    homeDirectory = "/home/${username}";
  };

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    userName = "${userfullname}";
    userEmail = "${useremail}";
  };

  home.packages = [ pkgs.omz ];
  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    history = {
      size = 20000;
      save = 20000;
    };
    initExtra = ''
      source ${pkgs.omz}/share/omz/omz.zsh
    '';
    shellAliases = {
      ls = "lsd";
      cat = "bat";
      svim = "sudoedit";
      nf = "neofetch";
      tmux = "tmux -T RGB,focus,overline,mouse,clipboard,usstyle";
      pastart = "pasuspender true";
      proxy_on = lib.mkDefault "export http_proxy=http://127.0.0.1:7890 https_proxy=http://127.0.0.1:7890 all_proxy=socks://127.0.0.1:7890";
      proxy_off = "export http_proxy= https_proxy= all_proxy=";
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
