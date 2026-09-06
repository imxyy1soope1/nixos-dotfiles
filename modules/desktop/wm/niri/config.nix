args@{
  config,
  lib,
  pkgs,
  assets,
  impure,
  ...
}:
let
  cfg = config.my.desktop.wm.niri;
in
{
  config = lib.mkIf config.my.desktop.wm.niri.enable {
    my.hm = {
      xdg.configFile."niri".source = impure.mkImpureLink ./config;
      xdg.configFile."niri-generated.kdl".text = (import ./_lib.nix args).mkNiriKDL cfg.settings;
    };

    my.desktop.wm.niri.settings = {
      environment.NIXOS_OZONE_WL = "1";

      spawn-at-startup = lib.mkBefore [
        (
          [
            "dbus-update-activation-environment"
            "--systemd"
          ]
          ++ (builtins.attrNames cfg.settings.environment)
        )
        [
          "${lib.getExe pkgs.swaybg}"
          "-m"
          "fill"
          "-i"
          (toString assets.wallpaper)
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

      binds = lib.mkMerge [
        {
          "Mod+G".spawn = [ config.my.desktop.browser.default.command ];
          "Mod+Return".spawn = [ config.my.desktop.terminal.default.command ];
        }
        (builtins.listToAttrs (
          map (n: {
            name = "Mod+${toString n}";
            value.focus-workspace = n;
          }) (lib.range 0 9)
        ))
        (builtins.listToAttrs (
          map (n: {
            name = "Mod+Shift+${toString n}";
            value.move-column-to-workspace = n;
          }) (lib.range 0 9)
        ))
      ];
    };
  };
}
