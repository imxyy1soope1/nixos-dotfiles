{
  config,
  lib,
  pkgs,
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

    programs.zsh.enable = true;
    programs.dconf.enable = true;

    my.home = {
      programs.home-manager.enable = true;
      programs.git = {
        enable = true;
        userName = "${userfullname}";
        userEmail = "${useremail}";
        extraConfig = {
          pull.rebase = true;
          push.autoSetupRemote = true;
        };
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
