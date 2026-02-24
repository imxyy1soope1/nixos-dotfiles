{
  config,
  lib,
  pkgs,
  impure,
  ...
}:
let
  cfg = config.my.desktop.style;
in
{
  options.my.desktop.style = {
    enable = lib.mkEnableOption "style";
  };

  config = lib.mkIf cfg.enable {
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
        icons = {
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
          theme = null;
          extraConfig = {
            gtk-decoration-layout = ":none";
            gtk-application-prefer-dark-theme = 1;
          };
        };
      };

      #QT
      qt = {
        enable = true;
        platformTheme.name = "kde";
        style = {
          package = with pkgs; [
            darkly-qt5
            darkly-qt6
          ];
          name = "Darkly";
        };
      };

      xdg.configFile = {
        kdeglobals.source = impure.mkImpureLink ./kdeglobals;
        plasmarc.text = ''
          [Theme]
          name=darkly
        '';
      };
    };
  };
}
