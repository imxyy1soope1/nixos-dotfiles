args@{
  lib,
  config,
  pkgs,
  assets,
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

  config = lib.mkIf cfg.enable {
    security.pam.services.login.enableGnomeKeyring = true;
    my.persist.homeDirs = [
      {
        directory = ".local/share/keyrings";
        mode = "0700";
      }
    ];
    xdg.portal = {
      enable = true;
      config = {
        niri = {
          default = [
            "gnome"
          ];
          "org.freedesktop.impl.portal.RemoteDesktop" = [ "gnome" ];
          "org.freedesktop.impl.portal.ScreenCast" = [ "gnome" ];
          "org.freedesktop.impl.portal.Screenshot" = [ "gnome" ];
          "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
        };
      };
      extraPortals = with pkgs; [
        xdg-desktop-portal-gnome
      ];
    };
    systemd.user.services.niri-flake-polkit.serviceConfig.ExecStart =
      lib.mkForce "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
    services.gnome.gnome-keyring.enable = true;
    programs.niri = {
      enable = true;
      package = pkg;
    };
    services.displayManager = {
      sddm = {
        enable = true;
        wayland.enable = true;
      };
    };
    my.hm = {
      home.packages = with pkgs; [
        xwayland-satellite-unstable

        wlr-randr
        wl-clipboard
        cliphist
        playerctl
        brightnessctl

        swaynotificationcenter
        nautilus

        noctalia-shell
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
        systemd.enable = false;
      };
      xdg.configFile."waybar/config.jsonc".text = builtins.toJSON (import ./waybar/config.nix args);
      xdg.configFile."waybar/style.css" = {
        source = ./waybar/style.css;
      };

      programs.noctalia-shell = {
        enable = true;
        settings = {
          audio.mprisBlacklist = [
            "firefox"
            "chromium"
            "zen"
          ];
          bar = {
            density = "comfortable";
            floating = true;
            marginHorizontal = 0.5;
            marginVertical = 0.5;
            showCapsule = false;
            widgets = {
              left = [
                {
                  customIconPath = "";
                  icon = "";
                  id = "ControlCenter";
                  useDistroLogo = true;
                }
                {
                  customFont = "";
                  formatHorizontal = "HH:mm MM月dd日 ddd";
                  formatVertical = "HH mm - dd MM";
                  id = "Clock";
                  useCustomFont = false;
                  usePrimaryColor = true;
                }
                {
                  id = "SystemMonitor";
                  showCpuTemp = false;
                  showCpuUsage = true;
                  showDiskUsage = false;
                  showMemoryAsPercent = false;
                  showMemoryUsage = true;
                  showNetworkStats = true;
                }
                {
                  hideUnoccupied = false;
                  id = "Workspace";
                  labelMode = "none";
                }
              ];
              center = [
                {
                  hideMode = "hidden";
                  id = "MediaMini";
                  scrollingMode = "hover";
                  showAlbumArt = true;
                  showVisualizer = true;
                  visualizerType = "wave";
                }
              ];
              right = [
                {
                  hideWhenZero = true;
                  id = "NotificationHistory";
                  showUnreadBadge = true;
                }
                {
                  blacklist = [ ];
                  colorizeIcons = false;
                  id = "Tray";
                }
                {
                  displayMode = "onhover";
                  id = "Volume";
                }
                {
                  displayMode = "onhover";
                  id = "Microphone";
                }
              ];
            };
          };
          # FIXME: Customize
          colorSchemes.predefinedScheme = "Tokyo-Night";
          controlCenter = {
            cards = [
              {
                enabled = true;
                id = "profile-card";
              }
              {
                enabled = true;
                id = "shortcuts-card";
              }
              {
                enabled = true;
                id = "audio-card";
              }
              {
                enabled = false;
                id = "weather-card";
              }
              {
                enabled = true;
                id = "media-sysmon-card";
              }
            ];
            shortcuts = {
              left = [ { id = "Bluetooth"; } ];
              right = [ { id = "Notifications"; } ];
            };
          };
          general = {
            avatarImage = "${assets.avatar}";
            scaleRatio = 1.05;
            radiusRatio = 0.8;
          };
          location.weatherEnabled = false;
          network.wifiEnabled = false;
          notifications = {
            alwaysOnTop = true;
            location = "top_center";
          };
          osd = {
            alwaysOnTop = true;
            location = "top_center";
          };
          setupCompleted = true;
          ui = {
            # I love Jetbrains Mono
            fontDefault = "Monospace";
            fontFixed = "Monospace";
          };
          wallpaper.enabled = false;
        };
      };
    };
  };
}