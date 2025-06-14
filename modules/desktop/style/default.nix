{
  config,
  lib,
  pkgs,
  ...
}:
lib.my.makeSwitch {
  inherit config;
  optionName = "style";
  optionPath = [
    "desktop"
    "style"
  ];
  config' = {
    my.home = {
      stylix = {
        enable = true;
        autoEnable = false;
        base16Scheme = ./tokyonight-storm.yaml;
        polarity = "dark";
        cursor = {
          package = pkgs.bibata-cursors;
          name = "Bibata-Modern-Classic";
          size = 24;
        };
        iconTheme = {
          enable = true;
          package = pkgs.win11-icon-theme;
          dark = "Win11";
          light = "Win11";
        };
      };

      # GTK
      gtk = {
        enable = true;
        theme = {
          package = pkgs.mono-gtk-theme;
          name = "MonoThemeDark";
        };
        gtk2 = {
          configLocation = "${config.my.home.xdg.configHome}/gtk-2.0/gtkrc";
        };
        gtk3 = {
          extraConfig = {
            gtk-decoration-layout = ":none";
            gtk-application-prefer-dark-theme = 1;
          };
        };
        gtk4 = {
          extraConfig = {
            gtk-decoration-layout = ":none";
            gtk-application-prefer-dark-theme = 1;
          };
        };
      };

      #QT
      qt = {
        enable = true;
        style.package = with pkgs; [
          darkly-qt5
          darkly-qt6
        ];
        platformTheme.name = "qtct";
      };
    };
  };
}
