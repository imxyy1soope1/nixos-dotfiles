{
  config,
  lib,
  pkgs,
  username,
  userfullname,
  useremail,
  ...
}:
lib.my.makeSwitch {
  inherit config;
  default = true;
  optionName = "misc command line tools";
  optionPath = [
    "cli"
    "misc"
  ];
  config' = {
    environment.systemPackages = with pkgs; [
      vim
      wget
      git

      file
      gnused
      gnutar

      zip
      unzip
      xz
      p7zip
      unrar-free

      pciutils
      usbutils

      lsof

      nmap
      traceroute
      tcping-go
      dnsutils

      killall
    ];

    programs.dconf.enable = true;

    my.home = {
      programs.home-manager.enable = true;
      programs.git = {
        enable = true;
        userName = "${userfullname}";
        userEmail = "${useremail}";
        signing = {
          format = "ssh";
          signByDefault = true;
          key = "/home/${username}/.ssh/id_ed25519";
        };
        extraConfig = {
          push.autoSetupRemote = true;
          gpg.ssh.allowedSignersFile =
            (pkgs.writeText "allowed_signers" ''
              imxyy1soope1@gmail.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOEFLUkyeaK8ZPPZdVNEmtx8zvoxi7xqS2Z6oxRBuUPO imxyy@imxyy-nix
              imxyy@imxyy.top ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOEFLUkyeaK8ZPPZdVNEmtx8zvoxi7xqS2Z6oxRBuUPO imxyy@imxyy-nix
            '').outPath;
        };
      };
      programs.lazygit = {
        enable = true;
      };

      home.packages = with pkgs; [
        lsd
        fd
        neofetch
        fzf
        bat
        ripgrep

        aria2
        socat

        nix-output-monitor

        tmux

        trash-cli

        cht-sh

        dooit

        # translate-shell
      ];
      xdg.configFile."tmux/tmux.conf".source = ./tmux.conf;
    };
  };
}
