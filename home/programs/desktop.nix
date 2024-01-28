{ config, pkgs, ... }: {
  # Firefox
  programs.firefox.enable = true;

  # Packages
  home.packages = with pkgs; [
    microsoft-edge

    dunst # notification daemon
    cinnamon.nemo # file explorer
    cinnamon.nemo-fileroller
    rofi

    pavucontrol

    xorg.xrdb
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
    package = pkgs.alacritty;
  };
  xdg.configFile."alacritty" = {
    source = ./alacritty;
    recursive = true;
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