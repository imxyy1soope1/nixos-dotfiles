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
      home.packages = with pkgs; [
        lsd
        fd
        neofetch
        fzf
        bat
        ripgrep

        aria2
        socat

        tmux

        trash-cli

        cht-sh

        dooit
      ];
      xdg.configFile."tmux/tmux.conf".source = ./tmux.conf;
    };
  };
}
