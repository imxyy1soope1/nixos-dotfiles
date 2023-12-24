{pkgs, ...}: {
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false; # To prevent from generating config
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
  xdg.configFile."hypr" = {
    source = ./hypr;
    recursive = true;
  };
}
