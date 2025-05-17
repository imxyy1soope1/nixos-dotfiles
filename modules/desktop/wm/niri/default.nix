args@{
  lib,
  config,
  pkgs,
  username,
  ...
}:
let
  cfg = config.my.desktop.wm.niri;
  pkg = pkgs.niri-unstable;
in
{
  options.my.desktop.wm.niri = {
    enable = lib.mkEnableOption "Niri";
  };

  imports = [
    (lib.mkIf cfg.enable (import ./config.nix args))
  ];

  config = lib.mkIf cfg.enable {
    xdg.portal = {
      enable = true;
      config = {
        niri = {
          default = [
            "gnome"
            "gtk"
          ];
          "org.freedesktop.impl.portal.Access" = [ "gtk" ];
          "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
          "org.freedesktop.impl.portal.Notification" = [ "gtk" ];
          "org.freedesktop.impl.portal.RemoteDesktop" = [ "gnome" ];
          "org.freedesktop.impl.portal.ScreenCast" = [ "gnome" ];
          "org.freedesktop.impl.portal.Screenshot" = [ "gnome" ];
          "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
        };
      };
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-gnome
      ];
    };
    programs.niri = {
      enable = true;
      package = pkg;
    };
    services.displayManager = {
      autoLogin = {
        enable = true;
        user = username;
      };
      sddm = {
        enable = true;
        wayland.enable = true;
        theme = "where_is_my_sddm_theme";
        extraPackages = [
          (pkgs.where-is-my-sddm-theme.override {
            variants = [ "qt6" ];
            themeConfig.General = {
              background = toString ./wallpaper.png;
            };
          })
        ];
      };
    };
    my.home = {
      home.packages = with pkgs; [
        wlr-randr
        wl-clipboard
        cliphist
        swaynotificationcenter
        nemo-with-extensions
      ];
      programs.wofi.enable = true;
      xdg.configFile."wofi" = {
        source = ./wofi;
        recursive = true;
      };
      xdg.configFile."wal" = {
        source = ./wal;
        recursive = true;
      };
      programs.waybar = {
        enable = true;
        systemd.enable = true;
      };
      xdg.configFile."waybar/config.jsonc".text = builtins.toJSON (import ./waybar/config.nix args);
      xdg.configFile."waybar/style.css" = {
        source = ./waybar/style.css;
      };
    };
  };
}
