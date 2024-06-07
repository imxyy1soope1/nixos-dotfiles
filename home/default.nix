{ config
, pkgs
, lib
, hostname
, username
, userfullname
, useremail
, ...
}: {
  imports = [
    ./hosts/${hostname}.nix
  ];

  nixpkgs.config = {
    allowUnfree = true;
    # Workaround for https://github.com/nix-community/home-manager/issues/2942
    allowUnfreePredicate = _: true;
  };

  home = {
    username = "${username}";
    homeDirectory = "/home/${username}";
  };

  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    userName = "${userfullname}";
    userEmail = "${useremail}";
    extraConfig = {
      pull.rebase = true;
    };
  };

  home.packages = [ pkgs.omz ];
  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    history = {
      path = "${config.xdg.stateHome}/zsh_history";
      ignorePatterns = [
        "la"
      ];
    };
    initExtra = ''
      source ${pkgs.omz}/share/omz/omz.zsh
    '';
    sessionVariables = {
      _ZL_DATA = "${config.xdg.stateHome}/zlua";
      _FZF_HISTORY = "${config.xdg.stateHome}/fzf_history";
    };
    shellAliases = {
      ls = "lsd";
      find = "fd";
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
