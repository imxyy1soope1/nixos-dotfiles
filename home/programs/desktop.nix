{ config, pkgs, ... }: {
  # Firefox
  programs.firefox.enable = true;

  programs.obs-studio.enable = true;

  # Packages
  home.packages = with pkgs; [
    microsoft-edge

    dunst # notification daemon
    cinnamon.nemo # file explorer
    cinnamon.nemo-fileroller

    pavucontrol

    xorg.xrdb

    vlc
    mpv

    shotwell

    thunderbird
  ];

  #Dunst
  xdg.configFile."dunst" = {
    source = ./dunst;
    recursive = true;
  };

  # Pywal
  xdg.configFile."wal" = {
    source = ./wal;
    recursive = true;
  };

  # Alacritty
  programs.alacritty = {
    enable = true;
  };
  xdg.configFile."alacritty" = {
    source = ./alacritty;
    recursive = true;
  };

  programs.foot = {
    enable = true;
    server.enable = true;
    settings = {
      main = {
        font = "monospace:size=14";
        initial-window-size-pixels = "800x600";
      };
      /* colors = {
        background = "24283b";
        foreground = "c0caf5";
        regular0 = "1D202F";
        regular1 = "f7768e";
        regular2 = "9ece6a";
        regular3 = "e0af68";
        regular4 = "7aa2f7";
        regular5 = "bb9af7";
        regular6 = "7dcfff";
        regular7 = "a9b1d6";
        bright0 = "414868";
        bright1 = "f7768e";
        bright2 = "9ece6a";
        bright3 = "e0af68";
        bright4 = "7aa2f7";
        bright5 = "bb9af7";
        bright6 = "7dcfff";
        bright7 = "c0caf5";
      }; */
      colors = {
        background = "24283b";
        foreground = "a9b1d6";
        regular0 = "32344a";
        regular1 = "f7768e";
        regular2 = "9ece6a";
        regular3 = "e0af68";
        regular4 = "7aa2f7";
        regular5 = "ad8ee6";
        regular6 = "449dab";
        regular7 = "9699a8";
        bright0 = "444b6a";
        bright1 = "ff7a93";
        bright2 = "b9f27c";
        bright3 = "ff9e64";
        bright4 = "7da6ff";
        bright5 = "bb9af7";
        bright6 = "0db9d7";
        bright7 = "acb0d0";
      };
    };
  };

  # Kitty
  programs.kitty.enable = true;
  xdg.configFile."kitty" = {
    source = ./kitty;
    recursive = true;
  };

  # Cursor
  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
  };

  # GTK
  gtk = {
    enable = true;
    theme = {
      package = pkgs.mono-gtk-theme;
      name = "MonoThemeDark";
    };
    iconTheme = {
      package = pkgs.win11-icon-theme;
      name = "Win11";
    };
    gtk2 = {
      extraConfig = ''
        gtk-decoration-layout = :none
      '';
      configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
    };
    gtk3 = {
      bookmarks = [
        "file:///home/imxyy/Documents 文档"
        "file:///home/imxyy/Downloads 下载"
        "file:///home/imxyy/Pictures 图片"
        "file:///home/imxyy/Videos 视频"
        "file:///home/imxyy/Music 音乐"
        "file:///home/imxyy/workspace 工作空间"
        "file:///home/imxyy/Documents/%E7%8F%AD%E7%BA%A7%E4%BA%8B%E5%8A%A1 班级事务"
        "file:///home/imxyy/U-NAS U-NAS"
        "file:///home/imxyy/U-NAS/imxyy_soope_ U-NAS imxyy_soope_"
        "file:///home/imxyy/U-NAS/imxyy_soope_/OS U-NAS OS"
      ];
      extraConfig = {
        gtk-decoration-layout = ":none";
      };
    };
    gtk4 = {
      extraConfig = {
        gtk-decoration-layout = ":none";
      };
    };
  };
}
