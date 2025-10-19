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
    catppuccin.sddm = {
      enable = true;
      font = "Jetbrains Mono";
      fontSize = "18";
    };
    services.displayManager.sddm = {
      package = pkgs.kdePackages.sddm;
      settings.Theme = {
        CursorTheme = "breeze-dark";
        CursorSize = 24;
      };
    };

    my.hm = {
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
        font = {
          name = "Adwaita Sans";
          package = pkgs.adwaita-fonts;
        };
        theme = {
          package = pkgs.gnome-themes-extra;
          name = "Adwaita";
        };
        gtk2 = {
          configLocation = "${config.my.hm.xdg.configHome}/gtk-2.0/gtkrc";
        };
        gtk3 = {
          theme = {
            package = pkgs.adw-gtk3;
            name = "adw-gtk3";
          };
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
          darker = pkgs.qt6Packages.qt6ct + /share/qt6ct/colors/darker.conf;
        };
      };
    };
  };
}
