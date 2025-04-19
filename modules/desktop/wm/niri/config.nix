{
  config,
  lib,
  pkgs,
  ...
}:
{
  my.home.systemd.user.services.swaync = {
    Unit.After = [ "graphical-session.target" ];
    Service.ExecStart = [ "swaync" ];
  };

  my.home.programs.niri.settings = {
    input = {
      focus-follows-mouse = {
        enable = true;
        max-scroll-amount = "40%";
      };
      workspace-auto-back-and-forth = true;
    };

    layout = {
      gaps = 23;
      center-focused-column = "never";
      always-center-single-column = true;
      focus-ring.enable = false;
      border = {
        enable = true;
        width = 4;

        inactive.color = "#2e2e3eee";
        active.gradient = {
          from = "#6186d6ee";
          to = "#cba6f7ee";
          angle = 180;
          relative-to = "workspace-view";
        };
      };
      preset-column-widths = [
        { proportion = 0.33333; }
        { proportion = 0.4; }
        { proportion = 0.5; }
        { proportion = 0.6; }
        { proportion = 0.66667; }
      ];
      default-column-width.proportion = 0.4;
    };

    animations = {
      enable = true;
      slowdown = 1.5;
      workspace-switch.spring = {
        damping-ratio = 1.0;
        stiffness = 1000;
        epsilon = 0.0001;
      };
    };

    prefer-no-csd = true;
    hotkey-overlay.skip-at-startup = true;

    window-rules = [
      {
        geometry-corner-radius = {
          bottom-left = 14.;
          bottom-right = 14.;
          top-left = 14.;
          top-right = 14.;
        };
        clip-to-geometry = true;
        draw-border-with-background = false;
      }
      {
        matches = [ { app-id = "kitty|foot|Alacritty|ghostty|chromium-browser|wofi"; } ];
        opacity = 0.8;
      }
      {
        matches = [ { app-id = "org.gnome.Nautilus|nemo"; } ];
        opacity = 0.6;
      }
    ];

    environment = {
      QT_QPA_PLATFORM = "wayland;xcb";
      XDG_SESSION_TYPE = "wayland";
      XDG_CURRENT_DESKTOP = "niri";
      XDG_SESSION_DESKTOP = "niri";
      QT_AUTO_SCREEN_SCALE_FACTOR = "1";
      STEAM_FORCE_DESKTOPUI_SCALING = "1.25";
      DISPLAY = ":0";
    };

    spawn-at-startup = map (c: { command = c; }) [
      [
        "alacritty"
        "--daemon"
      ]
      [ "${lib.getExe pkgs.xwayland-satellite-unstable}" ]
      [
        "${lib.getExe pkgs.swaybg}"
        "-i"
        (toString ./wallpaper.png)
      ]
      [
        "${lib.getExe pkgs.wl-clip-persist}"
        "--clipboard"
        "regular"
      ]
      [
        "wl-paste"
        "--type"
        "text"
        "--watch"
        "cliphist"
        "store"
      ]
      [
        "wl-paste"
        "--type"
        "image"
        "--watch"
        "cliphist"
        "store"
      ]
    ];

    binds =
      with config.my.home.lib.niri.actions;
      {
        "Ctrl+Alt+T".action.spawn = [
          "alacritty"
          "msg"
          "create-window"
        ];
        "Mod+T".action.spawn = [
          "alacritty"
          "msg"
          "create-window"
        ];
        "Mod+Return".action.spawn = [
          "alacritty"
          "msg"
          "create-window"
        ];
        "Mod+G".action.spawn = [ "chromium" ];
        "Mod+E".action.spawn = [ "nemo" ];
        "Mod+R".action.spawn = [
          "sh"
          "-c"
          "pkill wofi || wofi --color ~/.config/wal/colors"
        ];
        "Mod+V".action.spawn = [
          "sh"
          "-c"
          "pkill ${lib.getExe pkgs.wofi} || ${lib.getExe pkgs.cliphist} list | wofi --dmenu --color ~/.config/wal/colors | cliphist decode | wl-copy"
        ];

        "XF86AudioRaiseVolume" = {
          allow-when-locked = true;
          action.spawn = [
            "pamixer"
            "-i"
            "2"
          ];
        };
        "XF86AudioLowerVolume" = {
          allow-when-locked = true;
          action.spawn = [
            "pamixer"
            "-d"
            "2"
          ];
        };
        "XF86AudioMute" = {
          allow-when-locked = true;
          action.spawn = [
            "playerctl"
            "-i"
            "firefox,chromium"
            "play-pause"
          ];
        };
        "Mod+XF86AudioRaiseVolume" = {
          allow-when-locked = true;
          action.spawn = [
            "playerctl"
            "-i"
            "firefox,chromium"
            "next"
          ];
        };
        "Mod+XF86AudioLowerVolume" = {
          allow-when-locked = true;
          action.spawn = [
            "playerctl"
            "-i"
            "firefox,chromium"
            "previous"
          ];
        };

        "Mod+Q".action = close-window;

        "Mod+Left".action = focus-column-left;
        "Mod+Right".action = focus-column-right;
        "Mod+Up".action = focus-window-up;
        "Mod+Down".action = focus-window-down;

        "Mod+Ctrl+Left".action = move-column-left;
        "Mod+Ctrl+Right".action = move-column-right;
        "Mod+Ctrl+Up".action = move-window-up;
        "Mod+Ctrl+Down".action = move-window-down;

        "Mod+Shift+Left".action = focus-monitor-left;
        "Mod+Shift+Right".action = focus-monitor-right;
        "Mod+Shift+Up".action = focus-monitor-up;
        "Mod+Shift+Down".action = focus-monitor-down;

        "Mod+Shift+Ctrl+Left".action = move-column-to-monitor-left;
        "Mod+Shift+Ctrl+Right".action = move-column-to-monitor-right;
        "Mod+Shift+Ctrl+Up".action = move-column-to-monitor-up;
        "Mod+Shift+Ctrl+Down".action = move-column-to-monitor-down;

        "Mod+Page_Up".action = focus-workspace-up;
        "Mod+Page_Down".action = focus-workspace-down;

        "Mod+Ctrl+Page_Up".action = move-column-to-workspace-up;
        "Mod+Ctrl+Page_Down".action = move-column-to-workspace-down;

        "Mod+Shift+Page_Up".action = move-workspace-up;
        "Mod+Shift+Page_Down".action = move-workspace-down;

        "Mod+Comma".action = consume-window-into-column;
        "Mod+Period".action = expel-window-from-column;

        "Mod+L".action = switch-preset-column-width;
        "Mod+Shift+L".action = reset-window-height;
        "Mod+M".action = maximize-column;
        "Mod+Shift+M".action = fullscreen-window;
        "Mod+C".action = center-column;
        "Mod+F".action = toggle-window-floating;
        "Mod+H".action = expand-column-to-available-width;

        "Mod+Minus".action.set-column-width = "-10%";
        "Mod+Equal".action.set-column-width = "+10%";
        "Mod+Shift+Minus".action.set-window-height = "-10%";
        "Mod+Shift+Equal".action.set-window-height = "+10%";

        "Ctrl+Alt+A".action = screenshot;
        # "Print".action = screenshot-screen;
        "Alt+Print".action = screenshot-window;

        "Mod+Shift+E".action = quit;
      }
      // lib.attrsets.mergeAttrsList (
        map (n: {
          "Mod+${toString n}".action.focus-workspace = n;
          "Mod+Shift+${toString n}".action.move-column-to-workspace = n;
        }) (lib.range 0 9)
      );
  };
}
