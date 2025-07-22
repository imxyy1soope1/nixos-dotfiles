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
          package = pkgs.papirus-icon-theme;
          dark = "Papirus-Dark";
          light = "Papirus-Light";
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

      xdg.configFile = {
        "qt5ct/qt5ct.conf".source = pkgs.replaceVars ./qtct/qt5ct.conf {
          darker = pkgs.libsForQt5.qt5ct + /share/qt5ct/colors/darker.conf;
        };
        "qt6ct/qt6ct.conf".source = pkgs.replaceVars ./qtct/qt6ct.conf {
          darker = pkgs.qt6ct + /share/qt6ct/colors/darker.conf;
        };
      };
    };
  };
}
