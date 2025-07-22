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
      ];
      programs.tmux = {
        enable = true;
        extraConfig = "set-option -g mouse on";
        plugins = [
          (pkgs.tmuxPlugins.mkTmuxPlugin {
            pluginName = "tokyo-night-tmux";
            rtpFilePath = "tokyo-night.tmux";
            version = "legacy";
            src = pkgs.fetchFromGitHub {
              owner = "janoamaral";
              repo = "tokyo-night-tmux";
              rev = "16469dfad86846138f594ceec780db27039c06cd";
              hash = "sha256-EKCgYan0WayXnkSb2fDJxookdBLW0XBKi2hf/YISwJE=";
            };
          })
        ];
      };
      programs.tealdeer = {
        enable = true;
        enableAutoUpdates = true;
        settings.updates.auto_update = true;
      };
      programs.television = {
        enable = true;
        enableZshIntegration = true;
      };
    };
  };
}
