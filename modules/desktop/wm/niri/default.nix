{
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

        nautilus

        noctalia-shell
        xdg-terminal-exec
      ];

      programs.noctalia-shell = {
        enable = true;
        # modified from official Tokyo-Night theme
        colors = {
          mError = "#f7768e";
          mOnError = "#16161e";
          mOnPrimary = "#16161e";
          mOnSecondary = "#16161e";
          mOnSurface = "#c0caf5";
          mOnSurfaceVariant = "#9aa5ce";
          mOnTertiary = "#16161e";
          mOutline = "#565f89";
          mPrimary = "#7aa2f7";
          mSecondary = "#9a9ef7";
          mTertiary = "#bb9af7";
          # mSecondary = "#bb9af7";
          # mTertiary = "#9ece6a";
          mShadow = "#15161e";
          mSurface = "#1a1b26";
          mSurfaceVariant = "#24283b";
        };
        settings = {
          appLauncher = {
            enableClipboardHistory = true;
            useApp2Unit = true;
            terminalCommand = "kitty -e";
          };
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
                  id = "ControlCenter";
                  useDistroLogo = true;
                }
                {
                  id = "Clock";
                  formatHorizontal = "HH:mm MM/dd ddd";
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
                  id = "Workspace";
                  hideUnoccupied = false;
                  labelMode = "none";
                }
              ];
              center = [
                {
                  id = "MediaMini";
                  hideMode = "hidden";
                  scrollingMode = "hover";
                  showAlbumArt = true;
                  showVisualizer = true;
                  visualizerType = "wave";
                }
              ];
              right = [
                {
                  id = "NotificationHistory";
                  hideWhenZero = true;
                  showUnreadBadge = true;
                }
                {
                  id = "Tray";
                  colorizeIcons = false;
                }
                {
                  id = "Volume";
                  displayMode = "onhover";
                }
                {
                  id = "Microphone";
                  displayMode = "onhover";
                }
              ];
            };
          };
          controlCenter = {
            cards = [
              {
                id = "profile-card";
                enabled = true;
              }
              {
                id = "shortcuts-card";
                enabled = true;
              }
              {
                id = "audio-card";
                enabled = true;
              }
              {
                id = "weather-card";
                enabled = false;
              }
              {
                id = "media-sysmon-card";
                enabled = true;
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
