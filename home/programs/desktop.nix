{ pkgs, ... }: {
  # Firefox
  programs.firefox.enable = true;

  # Packages
  home.packages = with pkgs; [
    dunst # notification daemon
    cinnamon.nemo # file explorer
    rofi
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

  # Fcitx5
  xdg.dataFile."fcitx5" = {
    source = ./fcitx5;
    recursive = true;
  };

  # Alacritty
  programs.alacritty.enable = true;
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
      # package = pkgs.tokyo-night-gtk;
      # name = "Tokyonight-Storm-BL";
    };
    iconTheme = {
      package = pkgs.win11-icon-theme;
      name = "Win11";
      # package = pkgs.papirus-icon-theme;
      # name = "Papirus";
    };
  };
}
