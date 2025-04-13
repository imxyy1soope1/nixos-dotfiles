args@{
  lib,
  config,
  pkgs,
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
    programs.uwsm = {
      enable = true;
      waylandCompositors = {
        niri = {
          prettyName = "niri";
          comment = "Niri compositor managed by UWSM";
          binPath = pkgs.writeShellScript "niri-session" ''
            ${lib.getExe pkg} --session
          '';
        };
      };
    };
    programs.niri = {
      enable = true;
      package = pkg;
    };
    my.home = {
      home.packages = with pkgs; [
        wlr-randr
        wl-clipboard
        wl-clip-persist
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
