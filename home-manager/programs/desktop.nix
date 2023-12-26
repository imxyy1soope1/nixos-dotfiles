{ pkgs, ... }: {
  programs.firefox.enable = true;
  home.packages = with pkgs; [
    dunst
    cinnamon.nemo
  ];
  xdg.configFile."dunst" = {
    source = ./dunst;
    recursive = true;
  };
  xdg.configFile."wal" = {
    source = ./wal;
    recursive = true;
  };
  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
  };
  gtk = {
    enable = true;
    theme = {
      package = pkgs.tokyo-night-gtk;
      name = "Tokyonight-Storm-BL";
    };
  };
}
